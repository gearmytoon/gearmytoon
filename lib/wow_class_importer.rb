class WowClassImporter
  def self.import_all_classes
    class_names = ["Death Knight", "Druid", "Hunter", "Paladin", "Priest", "Rogue", "Shaman", "Warlock", "Warrior"]
    class_names.each do |class_name|
      WowClass.create!(:name => class_name, :stat_multipliers => "WowClass::StatMultipliers::#{class_name.gsub(/\s/, '')}".constantize)
    end
  end
end