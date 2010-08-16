module Upgradable

  def self.included(klass)
    klass.extend ClassMethods
  end
  
  def generate_upgrades
    self.class.upgrade_sources.each do |name, args|
      unless args[:disable_upgrade_lookup]
        if args[:item_sources]
          conditions = args[:item_sources].call
        end
        top_upgrades_from(args[:item_source_type], conditions, false) if args[:for].include?("pve")
        top_upgrades_from(args[:item_source_type], conditions, true) if args[:for].include?("pvp")
      end
    end
    self.update_attribute(:updated_at, Time.now.utc)
    self.found_upgrades!
  end

  def top_upgrades_from(item_source_type, conditions, for_pvp)
    upgrades = if conditions
      item_source_type.unique_items.including_item.also_include(conditions).usable_by(self.wow_class)
    else
      item_source_type.unique_items.including_item.usable_by(self.wow_class)
    end
    upgrades.each do |potential_upgrade_source|
      char_items = all_character_items
      char_items.select {|character_item| character_item.item.slot == potential_upgrade_source.item.slot}.each do |character_item|
        if(character_item != potential_upgrade_source.item)
          Upgrade.create!(:character => self, :new_item_source => potential_upgrade_source, :old_character_item => character_item, :for_pvp => for_pvp)
        end
      end
    end
  end

  module ClassMethods
    def upgrade_sources
      @upgrade_sources ||= {}
    end

    def has_upgrades_from(kind_of_upgrade, item_source_type, conditions_source, options = {:for => ["pve"]})
      upgrade_sources[kind_of_upgrade] = {:item_sources => conditions_source, 
                                          :for => options[:for], 
                                          :disable_upgrade_lookup => options[:disable_upgrade_lookup], 
                                          :item_source_type => item_source_type}
      if options[:for].include?("pvp")
        define_upgrade_methods("#{kind_of_upgrade}_pvp_upgrades", item_source_type, conditions_source, true)
      end
      if options[:for].include?("pve")
        define_upgrade_methods("#{kind_of_upgrade}_upgrades", item_source_type, conditions_source, false)
      end
    end

    private
    def define_upgrade_methods(name, item_source_type, conditions_source, pvp_flag)
      actual_upgrade_methods_name = "_#{name}"
      define_method(actual_upgrade_methods_name) do |*args| #upgrade method without pagination
        if conditions_source
          conditions = conditions_source.call(args)
          params = {:include => {item_source_type.name.underscore.to_sym => conditions[:include]}, :conditions => conditions[:conditions]}
          upgrades.with_sources.limit_to_type(item_source_type).also_include(params).pvp(pvp_flag).order_by_dps
        else
          upgrades.with_sources.limit_to_type(item_source_type).pvp(pvp_flag).order_by_dps
        end
      end
      define_method(name) do |page, *args|
        send(actual_upgrade_methods_name,*args).paginate(:page => page)
      end
      define_method("top_3_#{name}") do |*args|
        send(actual_upgrade_methods_name,*args).limited(3)
      end
    end

  end

end