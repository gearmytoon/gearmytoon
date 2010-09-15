class Spec < ActiveRecord::Base
  belongs_to :wow_class
  has_many :characters
  has_many :item_popularities
  
  def css_icon_name
    "#{self.wow_class.css_name}_#{name.gsub(/\s/, "").underscore}"
  end
  
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
  
  def summarize_all_characters
    all_character_scores = self.characters.all(:select => :gmt_score).map(&:gmt_score)
    count = all_character_scores.size
    average = all_character_scores.sum / count
    stddev = Math.sqrt( all_character_scores.inject(0) { |sum, e| sum + (e - average) ** 2 } / count.to_f )
    self.update_attributes!(:average_gmt_score => average, :gmt_score_standard_deviation => stddev)
  end
  
  def params_to_post
    {:average_gmt_score => self.average_gmt_score.to_s, :gmt_score_standard_deviation => self.gmt_score_standard_deviation.to_s, :spec_name => self.name, :wow_class_name => self.wow_class.name}
  end

  def self.find_by_wow_class_and_name(wow_class_name, spec_name)
    wow_class = WowClass.find_by_name(wow_class_name)
    spec = wow_class.specs.find_or_create_by_name(spec_name)
  end
end
