class DeathKnight < WowClass
  def armor_types
    [ArmorType.axe, ArmorType.mace, ArmorType.sword, ArmorType.sigil]
  end

  def hard_caps
    {:hit => 263}
  end

  def class_specific_multipliers(primary_spec, for_pvp)
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
