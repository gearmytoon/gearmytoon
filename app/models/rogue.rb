class Rogue < WowClass
  def armor_types
    [ArmorType.fist_weapon, ArmorType.sword, ArmorType.dagger, ArmorType.axe, 
      ArmorType.bow, ArmorType.gun, ArmorType.crossbow, ArmorType.mace, ArmorType.thrown]
  end
  
  def hard_caps
    {:hit => 886}
  end
  
  def class_specific_multipliers(primary_spec, for_pvp)
    case primary_spec
    when "Assassination"
      {:melee_dps => 170, :agility => 100, :expertise => 87, :hit => 83, :crit => 81, :attack_power => 65, :armor_penetration => 65, :haste => 64, :strength => 55}
    when "Combat"
      {:melee_dps => 220, :armor_penetration => 100, :agility => 100, :expertise => 82, :hit => 80, :crit => 75, :haste => 73, :strength => 55, :attack_power => 50}
    else # "Subtlety"
      {:melee_dps => 228, :expertise => 100, :agility => 100, :hit => 80, :armor_penetration => 75, :crit => 75, :haste => 75, :strength => 55, :attack_power => 50}
    end
  end
end
