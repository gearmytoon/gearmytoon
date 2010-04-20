class Character < ActiveRecord::Base
  def self.has_upgrades_from(kind_of_upgrade, item_sources)
    all_upgrades_method_name = "#{kind_of_upgrade}_upgrades"
    all_pvp_upgrades_method_name = "#{kind_of_upgrade}_pvp_upgrades"

    define_method(all_pvp_upgrades_method_name) do
      top_upgrades_from(item_sources.call, true)
    end
    define_method("top_3_#{kind_of_upgrade}_pvp_upgrades") do
      send(all_pvp_upgrades_method_name).first(3)
    end

    define_method(all_upgrades_method_name) do
      top_upgrades_from(item_sources.call, false)
    end
    define_method("top_3_#{kind_of_upgrade}_upgrades") do
      send(all_upgrades_method_name).first(3)
    end

  end

  has_upgrades_from :frost, Proc.new{EmblemSource.from_emblem_of_frost}
  has_upgrades_from :triumph, Proc.new{EmblemSource.from_emblem_of_triumph}
  has_upgrades_from :heroic_dungeon, Proc.new{DroppedSource.from_dungeons}
  has_upgrades_from :raid, Proc.new{DroppedSource.from_raids}
  has_upgrades_from :honor_point, Proc.new{HonorSource.all}
  has_upgrades_from :arena_point, Proc.new{ArenaSource.all}
  has_upgrades_from :wintergrasp_mark, Proc.new{EmblemSource.from_wintergrasp_mark_of_honor}

  attr_accessor :dont_use_wow_armory

  DEFAULT_LOCALE = 'us'
  LOCALES = [['US','us'],['EU','eu'],['CN','cn'],['TW','tw'],['KR','kr']]
  HORDE_RACES = ['orc', 'undead', 'troll', 'tauren', 'blood elf']
  ALLIANCE_RACES = ['dwarf', 'gnome', 'human', 'night elf', 'draenei']

  belongs_to :wow_class
  belongs_to :user
  has_many :character_items
  serialize :total_item_bonuses
  has_many :equipped_items, :through => :character_items, :source => :item
  has_friendly_id :name_and_realm_and_locale, :use_slug => true
  #TODO, do we need?
  before_validation :capitalize_name_and_realm
  before_validation :set_locale_default
  validates_uniqueness_of :name, :scope => [:realm, :locale]
  validates_presence_of :name
  validates_presence_of :realm
  validates_presence_of :locale

  def name_and_realm_and_locale
    "#{name} #{realm} #{locale}"
  end

  def top_upgrades_from(item_sources, for_pvp)
    potential_upgrade_sources = item_sources.for_items(wow_class.equippable_items)
    upgrades = potential_upgrade_sources.inject([]) do |found_upgrades, potential_upgrade_source|
      equipped_items.usable_in_same_slot_as(potential_upgrade_source.item).each do |equipped_item|
        if (dps_change = dps_for(stat_change_between(potential_upgrade_source.item, equipped_item),for_pvp)) > 0
          found_upgrades << Upgrade.new(potential_upgrade_source, equipped_item, dps_change)
        end
      end
      found_upgrades
    end.sort_by(&:dps_change).reverse
  end

  def wow_class_name
    wow_class.name
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

  private
  def set_locale_default
    self.locale = 'us' if self.locale.blank?
  end

  def capitalize_name_and_realm
    self.name.try(:capitalize!)
    self.realm.try(:capitalize!)
  end
end
