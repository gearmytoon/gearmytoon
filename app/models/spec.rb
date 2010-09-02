class Spec < ActiveRecord::Base
  belongs_to :wow_class
  has_many :characters
  
  def self.find_or_create(name, wow_class_name)
    wow_class_id = WowClass.find_by_name(wow_class_name).id
    Spec.find_or_create_by_name_and_wow_class_id(name, wow_class_id)
  end
end
