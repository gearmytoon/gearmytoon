module Upgradable
  
  def has_upgrades_from(kind_of_upgrade, item_sources)
    all_upgrades_method_name = "#{kind_of_upgrade}_upgrades"
    all_pvp_upgrades_method_name = "#{kind_of_upgrade}_pvp_upgrades"

    define_method(all_pvp_upgrades_method_name) do
      top_upgrades_from(item_sources.call, true)
    end
    define_method("top_3_#{kind_of_upgrade}_pvp_upgrades") do
      send(all_pvp_upgrades_method_name).first(3)
    end

    define_method(all_upgrades_method_name) do
      top_upgrades_from(item_sources.call, false)
    end
    define_method("top_3_#{kind_of_upgrade}_upgrades") do
      send(all_upgrades_method_name).first(3)
    end

  end
end