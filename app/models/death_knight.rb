class DeathKnight < WowClass
  def armor_types
    [ArmorType.axe, ArmorType.mace, ArmorType.sword, ArmorType.sigil]
  end

  def hard_caps
    {:hit => 263}
  end
  
  def is_a_tank?(point_distribution)
    matches = 0
    #DK tank talent locations, blade barrier, toughness, anticipation
    ({2 => "5", 30 => "5", 59 => "5"}).each do |location, value|
      matches +=1 if(point_distribution[location] && point_distribution[location].chr == value)
    end
    matches >= 2
  end

  def class_specific_multipliers(primary_spec, point_distribution, for_pvp)
    if is_a_tank?(point_distribution)
      case primary_spec
      when "Frost"
        {:melee_dps => 419, :parry => 100, :hit => 97, :strength => 96, :defense => 85, :expertise => 69, :dodge => 61, :agility => 61, :stamina => 61, :crit => 49, :attack_power => 41, :armor_penetration => 31, :armor => 5}
      else #2h tank
        {:melee_dps => 500, :stamina => 100, :defense => 90, :agility => 69, :dodge => 50, :parry => 43, :expertise => 38, :strength => 31, :armor_penetration => 26, :crit => 22, :armor => 18, :hit => 16, :haste => 16, :attack_power => 8}
      end
    else
      case primary_spec
      when "Frost"
        {:melee_dps => 337, :hit => 100, :strength => 97, :expertise => 81, :armor_penetration => 61, :crit => 45, :attack_power => 35, :haste => 28, :armor => 1}
      when "Unholy"
        {:melee_dps => 209, :strength => 100, :hit => 66, :expertise => 51, :haste => 48, :crit => 45, :attack_power => 34, :armor_penetration => 32, :armor => 1}
      else #Blood
        {:melee_dps => 360, :armor_penetration => 100, :strength => 99, :hit => 91, :expertise => 90, :crit => 57, :haste => 55, :attack_power => 36, :armor => 1}
      end
    end
  end
end
