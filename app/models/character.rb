class Character < ActiveRecord::Base
  include Upgradable
  
  DEFAULT_LOCALE = 'us'
  LOCALES = [['US','us'],['EU','eu'],['CN','cn'],['TW','tw'],['KR','kr']]
  HORDE_RACES = ['orc', 'undead', 'troll', 'tauren', 'blood elf']
  ALLIANCE_RACES = ['dwarf', 'gnome', 'human', 'night elf', 'draenei']

  has_upgrades_from :frost, Proc.new{['item_sources.wowarmory_token_item_id = ?', Item::FROST_EMBLEM_ARMORY_ID]}, :for => ['pve', 'pvp']
  has_upgrades_from :triumph, Proc.new{['item_sources.wowarmory_token_item_id = ?', Item::TRIUMPH_EMBLEM_ARMORY_ID]}, :for => ['pve', 'pvp']
  has_upgrades_from :heroic_dungeon, Proc.new{ ["item_sources.source_area_id IN (?)", Area.dungeons] }, :for => ['pve']
  has_upgrades_from :honor_point, Proc.new{"item_sources.type = 'HonorSource'"}, :for => ['pvp']
  has_upgrades_from :arena_point, Proc.new{"item_sources.type = 'ArenaSource'"}, :for => ['pvp']
  has_upgrades_from :wintergrasp_mark, Proc.new{['item_sources.wowarmory_token_item_id = ?', Item::WINTERGRASP_MARK_OF_HONOR]}, :for => ['pvp']
  has_upgrades_from :raid_25, Proc.new{ ["item_sources.source_area_id IN (?)", Area.raids_25] }, :for => ['pve']
  has_upgrades_from :area, Proc.new{|area|["item_sources.source_area_id = ?",area]}, :for => ['pve'], :disable_upgrade_lookup => true
  has_upgrades_from :raid_10, Proc.new{ ["item_sources.source_area_id IN (?)", Area.raids_10] }, :for => ['pve']

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
  has_many :upgrades
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

  def dps_for(item_bonuses, for_pvp)
    wow_class.stat_multipliers(primary_spec, for_pvp).inject(0) do |total_dps, relative_bonus_dps_value|
      stat_name, relative_dps_value = relative_bonus_dps_value
      total_dps += relative_dps_value * (item_bonuses[stat_name] ? item_bonuses[stat_name] : 0)
    end
  end
  
  def dps_for_after_hard_caps(change_in_bonuses, for_pvp)
    dps_for(apply_hard_caps(change_in_bonuses), for_pvp)
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
    user_characters.paided_for.any?
  end

  def refresh_in_background!
    unless self.character_refreshes.recent.active.any?
      Resque.enqueue(CharacterJob, self.character_refreshes.create!.id)
    end
  end

  def character_item_on(slot_name)
    character_items.equipped_on(slot_name)
  end
  
  def all_character_items
    @char_items ||= character_items.all
  end
  
  def find_best_gem(socket_color, new_items_bonuses, for_pvp)
    GemItem.compatible_gem_colors(socket_color).inject(nil) do |best_gem, color|
      other_gem = find_best_gem_from_cache_or_lookup(color, new_items_bonuses, for_pvp)
      if best_gem.nil?
        other_gem
      elsif other_gem.nil?
        best_gem
      else
        best_gem_bonuses = apply_hard_caps(best_gem.bonuses.add_values(new_items_bonuses))
        other_gem_bonuses = apply_hard_caps(other_gem.bonuses.add_values(new_items_bonuses))
        if (dps_for(other_gem_bonuses, for_pvp) > dps_for(best_gem_bonuses, for_pvp))
          other_gem
        else
          best_gem
        end
      end
    end
  end

  def find_best_gem_from_cache_or_lookup(socket_color, new_items_bonuses, for_pvp)
    @best_gem_for_color ||= {}
    if @best_gem_for_color[socket_color]
      @best_gem_for_color[socket_color]
    else
      @best_gem_for_color[socket_color] = find_best_gem_for_specific_color_socket(socket_color, new_items_bonuses, for_pvp)
    end
  end
  
  def find_best_gem_for_specific_color_socket(socket_color, new_items_bonuses, for_pvp)
    GemItem.with_color(socket_color).inject(nil) do |best_gem, gem_item|
      if best_gem.nil?
        gem_item
      else
        best_gem_bonuses = apply_hard_caps(best_gem.bonuses.add_values(new_items_bonuses))
        other_gem_bonuses = apply_hard_caps(gem_item.bonuses.add_values(new_items_bonuses))
        if (dps_for(other_gem_bonuses, for_pvp) > dps_for(best_gem_bonuses, for_pvp))
          gem_item
        else
          best_gem
        end
      end
    end
  end

  private
  def capitalize_name_and_realm
    self.name.try(:capitalize!)
    self.realm.try(:capitalize!)
  end
end
