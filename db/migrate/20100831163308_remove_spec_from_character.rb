class RemoveSpecFromCharacter < ActiveRecord::Migration
  
  def self.up
    Character.find_in_batches() do |group|
      group.each do |character|
        character.update_attribute(:spec, Spec.find_or_create(character.primary_spec, character.wow_class_id))
      end
    end
  end

  def self.down
  end
end
class Character < ActiveRecord::Base
  belongs_to :wow_class
  belongs_to :spec
end
class WowClass < ActiveRecord::Base
  has_many :spec
end
class Spec < ActiveRecord::Base
  belongs_to :wow_class
  def self.find_or_create(name, wow_class_id)
    Spec.find_or_create_by_name_and_wow_class_id(name, wow_class_id)
  end
end
