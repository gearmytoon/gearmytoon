class WowClassImporter
  def self.import_all_classes
    WowClass.create_all_classes!
  end
end