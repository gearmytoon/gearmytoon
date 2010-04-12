class Mage < WowClass
  def armor_types
    [ArmorType.dagger, ArmorType.sword, ArmorType.staff, ArmorType.wand]
  end

  def hard_caps
    {:hit => 263}
  end

  def class_specific_multipliers(primary_spec, for_pvp)
    case primary_spec
    when "Arcane"
      {:hit => 100, :haste => 54, :spell_power => 49, :crit => 37, :intellect => 34, :spirit => 14}
    when "Frost"
      {:hit => 100, :haste => 42, :spell_power => 39, :crit => 19, :intellect => 6}
    else # Fire
      {:hit => 100, :haste => 53, :spell_power => 46, :crit => 43, :intellect => 13}
    end
  end
end
