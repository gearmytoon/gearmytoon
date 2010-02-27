class ArmorType < ActiveRecord::Base
  has_many :wow_classes, :foreign_key => "primary_armor_type_id"
  has_many :items
  
  class << self
    ["Leather", "Plate", "Mail", "Cloth"].each do |armor_type|
      define_method(armor_type) do
        ArmorType.find_or_create_by_name(armor_type)
      end
    end
  end
end
