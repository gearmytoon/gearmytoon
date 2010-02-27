class WowClassImporter
  def self.import_all_classes
    class_names = ["Death Knight", "Druid", "Hunter", "Paladin", "Priest", "Rogue", "Shaman", "Warlock", "Warrior"]
    class_names.each do |class_name|
      WowClass.create!("WowClass::WowClassConstants::#{class_name.gsub(/\s/, '')}".constantize)
    end
  end
end