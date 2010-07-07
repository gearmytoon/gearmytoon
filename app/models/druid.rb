class Druid < WowClass
  def armor_types
    [ArmorType.dagger, ArmorType.fist_weapon, ArmorType.mace, ArmorType.polearm, ArmorType.staff, ArmorType.idol]
  end
  
  def hard_caps
    {:hit => 263}
  end

  def is_a_tank?(point_distribution)
    matches = 0
    #Natural Reaction, Survival of the Fittest, Protector of the Pack
    ({43 => "3", 45 => "3", 49 => "3"}).each do |location, value|
      matches +=1 if(point_distribution[location] && point_distribution[location].chr == value)
    end
    matches == 3
  end

  def class_specific_multipliers(primary_spec, point_distribution, for_pvp)
    case primary_spec
    when "Balance"
      {:hit => 100, :spell_power => 66, :haste => 54, :crit => 43, :spirit => 22, :intellect => 22}
    when "Restoration"
      {:spell_power => 100, :mana_regen => 73, :haste => 57, :intellect => 51, :spirit => 32, :crit => 11}
    else 
      if is_a_tank?(point_distribution)
        {:agility => 100, :stamina => 75, :dodge => 65, :defense => 60, :expertise => 16, :strength => 10, :armor => 10, :hit => 8, :haste => 5, :attack_power => 4, :feral_attack_power => 4, :crit => 3}
      else #Feral Combat - dps
        {:agility => 100, :armor_penetration => 90, :strength => 80, :crit => 55, :expertise => 50, :hit => 50, :feral_attack_power => 40, :attack_power => 40, :haste => 35}
      end
    end
  end
end
