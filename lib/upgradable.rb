module Upgradable

  def self.included(klass)
    klass.extend ClassMethods
  end
  
  def generate_upgrades
    self.class.upgrade_sources.each do |name, item_sources|
      top_upgrades_from(item_sources.call, false)
    end
  end

  def top_upgrades_from(item_sources, for_pvp)
    potential_upgrade_sources = item_sources.for_items(wow_class.equippable_items)
    upgrades = potential_upgrade_sources.each do |potential_upgrade_source|
      all_equipped = equipped_items.all
      all_equipped.select {|equip| equip.slot == potential_upgrade_source.item.slot}.each do |equipped_item|
        if(equipped_item != potential_upgrade_source.item)
          Upgrade.create!(:character => self, :new_item_source => potential_upgrade_source, :old_item => equipped_item, :for_pvp => for_pvp)
        end
      end
    end
  end

  module ClassMethods
    def upgrade_sources
      @upgrade_sources ||= {}
    end

    def has_upgrades_from(kind_of_upgrade, item_sources)
      upgrade_sources[kind_of_upgrade] = item_sources
      all_upgrades_method_name = "#{kind_of_upgrade}_upgrades"
      all_pvp_upgrades_method_name = "#{kind_of_upgrade}_pvp_upgrades"

      define_upgrade_method(all_upgrades_method_name, item_sources, false)
      define_upgrade_method(all_pvp_upgrades_method_name, item_sources, true)
      define_top_3_upgrade_method("top_3_#{kind_of_upgrade}_upgrades", all_upgrades_method_name)
      define_top_3_upgrade_method("top_3_#{kind_of_upgrade}_pvp_upgrades", all_pvp_upgrades_method_name)
    end

    private
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

end