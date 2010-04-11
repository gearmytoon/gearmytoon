class Priest < WowClass
  def armor_types
    [ArmorType.dagger, ArmorType.mace, ArmorType.staff, ArmorType.wand]
  end

  def hard_caps
    {:hit => 263}
  end

  def class_specific_multipliers(primary_spec, for_pvp)
    case primary_spec
    when "Holy"
      {:mana_regen => 100, :intellect => 69, :spell_power => 60, :spirit => 52, :crit => 38, :haste => 31}
    when "Shadow"
      {:hit => 100, :spell_power => 76, :crit => 54, :haste => 50, :spirit => 16, :intellect => 16}
    else #Discipline
      {:spell_power => 100, :mana_regen => 67, :intellect => 65, :haste => 59, :crit => 48, :spirit => 22}
    end
  end
end
