class Paladin < WowClass
  def armor_types
    [ArmorType.axe, ArmorType.mace, ArmorType.sword, ArmorType.polearm, ArmorType.libram]
  end

  def hard_caps
    {:hit => 263}
  end

  def stat_multipliers(primary_spec, for_pvp)
    case primary_spec
    when "Protection"
      {:stamina => 100, :agility => 60, :expertise => 59, :dodge => 55, :defense => 45, :parry => 30, :strength => 16, :armor => 8, :block => 7, :block_value => 6}
    when "Holy"
      {:intellect => 100, :mana_regen => 88, :spell_power => 58, :crit => 46, :haste => 35}
    else #assume  
      {:melee_dps => 470, :hit => 100, :strength => 80, :expertise => 66, :crit => 40, :attack_power => 34, :agility => 32, :haste => 30, :armor_penetration => 22, :spell_power => 9}
    end
  end
end
