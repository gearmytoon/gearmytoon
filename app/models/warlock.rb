class Warlock < WowClass
  def armor_types
    [ArmorType.dagger, ArmorType.staff, ArmorType.sword, ArmorType.wand]
  end
  
  def hard_caps
    {:hit => 263}
  end

  def stat_multipliers(primary_spec, for_pvp)
    case primary_spec
    when "Destruction"
      {:hit => 100, :spell_power => 47, :haste => 46, :spirit => 26, :crit => 16, :intellect => 13}
    when "Demonology"
      {:hit => 100, :haste => 50, :spell_power => 45, :crit => 31, :spirit => 29, :intellect => 13}
    else #Affliction
      {:hit => 100, :spell_power => 72, :haste => 61, :crit => 38, :spirit => 34, :intellect => 15}
    end
  end
end
