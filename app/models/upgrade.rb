class Upgrade
  attr_accessor :new_item, :old_item
  def initialize(character, new_item, old_item)
    @new_item = new_item
    @old_item = old_item
    @character = character
  end

  def dps_change
    @new_item.dps_compared_to_for_character(old_item, @character)
  end
end
