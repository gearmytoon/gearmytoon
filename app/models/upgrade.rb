class Upgrade
  attr_accessor :new_item, :old_item
  def initialize(new_item, old_item)
    @new_item = new_item
    @old_item = old_item
  end
  
  def dps_change
    @new_item.dps_compared_to(old_item)
  end
end