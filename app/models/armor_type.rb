class ArmorType < ActiveRecord::Base
  has_many :wow_classes, :foreign_key => "primary_armor_type_id"
  has_many :items
end
