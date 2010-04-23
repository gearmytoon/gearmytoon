class Upgrade
  attr_accessor :old_item, :dps_change, :new_item_source
  def initialize(new_item_source, old_item, dps_change)
    @new_item_source = new_item_source
    @old_item = old_item
    @dps_change = dps_change
  end
  
  def new_item
    @new_item_source.item
  end
  
  def new_item_source_type
    @new_item_source.class.name.gsub(/Source/,"").downcase
  end
  
  def kind_of_change
    @dps_change > 0 ? "upgrade" : "downgrade"
  end
end
