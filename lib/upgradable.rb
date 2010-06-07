module Upgradable

  def has_upgrades_from(kind_of_upgrade, item_sources)
    self.upgrade_sources[kind_of_upgrade] = item_sources
    all_upgrades_method_name = "#{kind_of_upgrade}_upgrades"
    all_pvp_upgrades_method_name = "#{kind_of_upgrade}_pvp_upgrades"

    define_upgrade_method(all_upgrades_method_name, item_sources, false)
    define_upgrade_method(all_pvp_upgrades_method_name, item_sources, true)
    define_top_3_upgrade_method("top_3_#{kind_of_upgrade}_upgrades", all_upgrades_method_name)
    define_top_3_upgrade_method("top_3_#{kind_of_upgrade}_pvp_upgrades", all_pvp_upgrades_method_name)
  end
  
  def define_upgrade_method(name, item_sources, pvp_flag)
    define_method(name) do |*args|
      upgrades.with_sources(item_sources.call(args))
    end
  end

  def define_top_3_upgrade_method(name, upgrade_method)
    define_method(name) do |*args|
      send(upgrade_method,*args).first(3)
    end
  end
end