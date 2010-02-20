class Character < ActiveRecord::Base
  has_many :character_items
  has_many :equipped_items, :through => :character_items, :source => :item

  def top_3_frost_upgrades
    Item.from_emblem_of_frost
  end
end
