class Druid < WowClass
  def armor_types
    [ArmorType.dagger, ArmorType.fist_weapon, ArmorType.mace, ArmorType.polearm, ArmorType.staff, ArmorType.idol]
  end
  
  def hard_caps
    {:hit => 263}
  end

  def stat_multipliers(primary_spec, for_pvp)
    case primary_spec
    when "Balance"
      {:hit => 100, :spell_power => 66, :haste => 54, :crit => 43, :spirit => 22, :intellect => 22}
    when "Restoration"
      {:spell_power => 100, :mana_regen => 73, :haste => 57, :intellect => 51, :spirit => 32, :crit => 11}
    else #Feral Combat - dps
      {:agility => 100, :armor_penetration => 90, :strength => 80, :crit => 55, :expertise => 50, :hit => 50, :feral_attack_power => 40, :attack_power => 40, :haste => 35}
    end
  end
end
