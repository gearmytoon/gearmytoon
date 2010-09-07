class Spec < ActiveRecord::Base
  belongs_to :wow_class
  has_many :characters
  
  def self.find_or_create(name, wow_class_name)
    wow_class = WowClass.find_by_name(wow_class_name)
    Spec.find_or_create_by_name_and_wow_class_id(name, wow_class.id)
  end
  
  def self.all_played_specs
    valid_specs = YAML.load_file(File.join(RAILS_ROOT, "config", "possible_specs.yml"))
    all(:include => :wow_class).select do |spec|
      valid_specs.any? do |valid_class_specs|
        spec.wow_class && valid_class_specs.keys.first == spec.wow_class.name && valid_class_specs.values.first['specs'].include?(spec.name)
      end
    end
  end
end
