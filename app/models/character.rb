class Character < ActiveRecord::Base
  attr_accessor :dont_use_wow_armory

  belongs_to :wow_class
  belongs_to :user
  has_many :character_items
  serialize :total_item_bonuses
  has_many :equipped_items, :through => :character_items, :source => :item
  has_friendly_id :name_and_realm, :use_slug => true

  before_save :import_items_from_wow_armory

  before_validation :capitalize_name_and_realm
  validates_uniqueness_of :name, :scope => :realm

  def name_and_realm
    "#{name} #{realm}"
  end

  def upgrades_in(area)
    top_upgrades_for(area.items_dropped_in)
  end

  def top_3_frost_upgrades
    frost_upgrades.slice(0,3)
  end

  def frost_upgrades
    top_upgrades_for(wow_class.equippable_items.from_emblem_of_frost)
  end

  def triumph_upgrades
    top_upgrades_for(wow_class.equippable_items.from_emblem_of_triumph)
  end

  def dungeon_upgrades
    top_upgrades_for(wow_class.equippable_items.from_heroic_dungeon)
  end

  def top_3_triumph_upgrades
    triumph_upgrades.slice(0,3)
  end

  def top_3_heroic_dungeon_upgrades
    dungeon_upgrades.slice(0,3)
  end

  def top_upgrades_for(potential_upgrades)
    upgrades = potential_upgrades.inject([]) do |found_upgrades, potential_upgrade|
      equipped_items.usable_in_same_slot_as(potential_upgrade).each do |equipped_item|
        if (dps_change = dps_for(stat_change_between(potential_upgrade, equipped_item))) > 0
          found_upgrades << Upgrade.new(potential_upgrade, equipped_item, dps_change)
        end
      end
      found_upgrades
    end.sort_by(&:dps_change).reverse
  end

  def top_3_upgrades_for(potential_upgrades)
    top_upgrades_for(potential_upgrades).slice(0, 3)
  end

  def wow_class_name
    wow_class.name
  end

  def dps_for(item_bonuses)
    wow_class.stat_multipliers(primary_spec).inject(0) do |total_dps, relative_bonus_dps_value|
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

  def self.find_by_name_and_realm_or_create_from_wowarmory(name, realm)
    character = Character.find_by_name_and_realm(name, realm)
    if character
      return character
    else
      import_items_from_wow_armory
    end
  end

  private
  def import_items_from_wow_armory
    CharacterImporter.import_character_and_all_items(self) unless dont_use_wow_armory
  end

  def capitalize_name_and_realm
    self.name.capitalize!
    self.realm.capitalize!
  end
end
