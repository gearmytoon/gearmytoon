class Hunter < WowClass
  def armor_types
    [ArmorType.fist_weapon, ArmorType.sword, ArmorType.dagger, ArmorType.axe, ArmorType.bow, 
      ArmorType.gun, ArmorType.crossbow, ArmorType.thrown, ArmorType.staff, ArmorType.polearm]
  end

  def hard_caps
    {:hit => 263}
  end
  
  def stat_multipliers(primary_spec, for_pvp)
    case primary_spec
    when "Survival"
      {:ranged_min_damage => 900, :ranged_max_damage => 910, :ranged_attack_speed => 50, :hit => 100, :agility => 76, :crit => 42, :intellect => 35, :haste => 31, :attack_power => 29, :armor_penetration => 26}
    when "Beast Mastery"
      {:ranged_min_damage => 900, :ranged_max_damage => 910, :ranged_attack_speed => 50, :hit => 100, :agility => 58, :crit => 40, :intellect => 37, :haste => 21, :attack_power => 30, :armor_penetration => 28}
    else #assume Marksmanship
      {:ranged_min_damage => 900, :ranged_max_damage => 910, :ranged_attack_speed => 50, :hit => 100, :agility => 74, :crit => 57, :intellect => 39, :haste => 24, :attack_power => 32, :armor_penetration => 40}
    end
  end
end
