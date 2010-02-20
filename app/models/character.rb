class Character < ActiveRecord::Base
  has_many :character_items
  has_many :equipped_items, :through => :character_items, :source => :item
  
  def dps_for(item)
    convert_bonuses_to_dps(item.bonuses)
  end
  
  def convert_bonuses_to_dps(bonuses) #this should become a relation of the character class(ruby class) through the characters class(wow class)
    relative_bonus_dps_values = {:attack_power => 0.5, :agility => 1, :armor_penetration => 1.1, :crit => 0.75, :haste => 0.7, :hit => 0.8}
    relative_bonus_dps_values.inject(0) do |total_dps, relative_bonus_dps_value|
      stat_name, relative_dps_value = relative_bonus_dps_value
      total_dps += relative_dps_value * (bonuses[stat_name] ? bonuses[stat_name] : 0)
    end
  end
end
