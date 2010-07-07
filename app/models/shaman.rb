class Shaman < WowClass
  def armor_types
    [ArmorType.axe, ArmorType.dagger, ArmorType.mace, ArmorType.fist_weapon,
      ArmorType.staff, ArmorType.totem]
  end
  
  def hard_caps
    {:hit => 263}
  end

  def class_specific_multipliers(primary_spec, point_distribution, for_pvp)
    case primary_spec
    when "Enhancement"
      {:melee_dps => 135, :hit => 100, :expertise => 84, :agility => 55, :intellect => 55, :crit => 55, :haste => 42, :strength => 35, :attack_power => 32, :spell_power => 29, :armor_penetration => 26}
    when "Restoration"
      {:mana_regen => 100, :intellect => 85, :spell_power => 77, :crit => 62, :haste => 35}
    else #Elemental
      {:hit => 100, :spell_power => 60, :haste => 56, :crit => 40, :intellect => 11}
    end
  end
end
