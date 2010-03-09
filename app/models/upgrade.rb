class Upgrade
  attr_accessor :new_item, :old_item
  def initialize(wow_class, new_item, old_item)
    @new_item = new_item
    @old_item = old_item
    @wow_class = wow_class
  end

  def dps_change
    @new_item.dps_compared_to_for_class(old_item, @wow_class)
  end
end
