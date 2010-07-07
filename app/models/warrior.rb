class Warrior < WowClass

  def armor_types
    [ArmorType.sword, ArmorType.axe, ArmorType.dagger, ArmorType.mace, ArmorType.fist_weapon, ArmorType.staff,
      ArmorType.gun, ArmorType.bow, ArmorType.crossbow, ArmorType.thrown]
  end

  def hard_caps
    {:hit => 263}
  end

  def class_specific_multipliers(primary_spec, point_distribution, for_pvp)
    case primary_spec
    when "Protection"
      {:stamina => 100, :dodge => 90, :defense => 86, :block_value => 81, :agility => 67, :parry => 67, :block => 48, :strength => 48, :expertise => 19, :hit => 10, :armor_penetration => 10, :crit => 7, :armor => 6, :haste => 1, :attack_power => 1}
    else #fury and arms
      {:expertise => 100, :strength => 82, :crit => 66, :agility => 53, :armor_penetration => 52, :hit => 48, :haste => 36, :attack_power => 31, :armor => 5}
    end
  end
end
