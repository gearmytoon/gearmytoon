class Character < ActiveRecord::Base
  extend Upgradable
  DEFAULT_LOCALE = 'us'
  LOCALES = [['US','us'],['EU','eu'],['CN','cn'],['TW','tw'],['KR','kr']]
  HORDE_RACES = ['orc', 'undead', 'troll', 'tauren', 'blood elf']
  ALLIANCE_RACES = ['dwarf', 'gnome', 'human', 'night elf', 'draenei']

  has_upgrades_from :frost, Proc.new{EmblemSource.from_emblem_of_frost}
  has_upgrades_from :triumph, Proc.new{EmblemSource.from_emblem_of_triumph}
  has_upgrades_from :heroic_dungeon, Proc.new{DroppedSource.from_dungeons}
  has_upgrades_from :honor_point, Proc.new{HonorSource.all}
  has_upgrades_from :arena_point, Proc.new{ArenaSource.all}
  has_upgrades_from :wintergrasp_mark, Proc.new{EmblemSource.from_wintergrasp_mark_of_honor}
  has_upgrades_from :raid_25, Proc.new{DroppedSource.from_raids_25}
  has_upgrades_from :area, Proc.new{ |area| DroppedSource.from_area(area)}
  has_upgrades_from :raid_10, Proc.new{DroppedSource.from_raids_10}
  acts_as_state_machine :initial => :new, :column => "status"

  state :new
  state :found
  state :does_not_exist
  event :loaded do
    transitions :to => :found, :from => [:new, :does_not_exist]
  end
  event :unable_to_load do
    transitions :to => :does_not_exist, :from => [:new, :found]
  end

  attr_accessor :dont_use_wow_armory

  named_scope :found, :conditions => {:status => "found"}
  named_scope :level_80, :conditions => {:level => "80"}

  belongs_to :wow_class
  has_many :character_items
  has_many :character_refreshes
  serialize :total_item_bonuses
  has_many :equipped_items, :through => :character_items, :source => :item
  has_many :user_characters
  has_many :subscribers, :through => :user_characters, :source => :subscriber
  has_friendly_id :name_and_realm_and_locale, :use_slug => true
  validates_uniqueness_of :name, :scope => [:realm, :locale]
  validates_presence_of :name
  validates_presence_of :realm
  validates_presence_of :locale

  delegate :name, :to => :wow_class, :prefix => true

  def name_and_realm_and_locale
    "#{name} #{realm} #{locale}"
  end

  def top_upgrades_from(item_sources, for_pvp)
    potential_upgrade_sources = item_sources.for_items(wow_class.equippable_items)
    upgrades = potential_upgrade_sources.inject([]) do |found_upgrades, potential_upgrade_source|
      all_equipped = equipped_items.all
      all_equipped.select {|equip| equip.slot == potential_upgrade_source.item.slot}.each do |equipped_item|
        if(equipped_item != potential_upgrade_source.item)
          dps_change = dps_for(stat_change_between(potential_upgrade_source.item, equipped_item),for_pvp)
          found_upgrades << Upgrade.new(potential_upgrade_source, equipped_item, dps_change)
        end
      end
      found_upgrades
    end.sort_by(&:dps_change).reverse
  end

  def dps_for(item_bonuses, for_pvp)
    wow_class.stat_multipliers(primary_spec, for_pvp).inject(0) do |total_dps, relative_bonus_dps_value|
      stat_name, relative_dps_value = relative_bonus_dps_value
      total_dps += relative_dps_value * (item_bonuses[stat_name] ? item_bonuses[stat_name] : 0)
    end
  end

  def stat_change_between(new_item, old_item)
    apply_hard_caps(new_item.change_in_stats_from(old_item))
  end

  def apply_hard_caps(change_in_bonuses)
    bonuses_after_hard_cap = {}
    change_in_bonuses.slice(*hard_caps.keys).each do |key, value|
      total_bonus_for_stat = total_item_bonuses.has_key?(key) ? total_item_bonuses[key] : 0.0
      if((value + total_bonus_for_stat) > hard_caps[key])
        bonuses_after_hard_cap[key] = [hard_caps[key] - total_bonus_for_stat, 0].max
      end
    end
    return change_in_bonuses.merge(bonuses_after_hard_cap)
  end

  def hard_caps
    wow_class.hard_caps
  end

  def faction
    return 'horde' if HORDE_RACES.include?(race.downcase)
    return 'alliance' if ALLIANCE_RACES.include?(race.downcase)
  end

  def paid?
    subscribers.map(&:active_subscriber?).any? || subscribers.map(&:free_access).any?
  end

  def refresh_in_background!
    Resque.enqueue(CharacterJob, self.character_refreshes.create!.id)
  end

  private
  def capitalize_name_and_realm
    self.name.try(:capitalize!)
    self.realm.try(:capitalize!)
  end
end
