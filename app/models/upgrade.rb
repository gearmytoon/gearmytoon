class Upgrade
  attr_accessor :new_item, :old_item, :dps_change
  def initialize(new_item, old_item, dps_change)
    @new_item = new_item
    @old_item = old_item
    @dps_change = dps_change
  end
end
