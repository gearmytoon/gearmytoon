class Character < ActiveRecord::Base
  has_many :character_items
  has_many :equipped_items, :through => :character_items, :source => :item
  
end
