require File.dirname(__FILE__) + '/../test_helper'

class WowClassImporterTest < ActiveSupport::TestCase
  context "import_all_classes" do
    should "import all 10 classes" do
      assert_difference "WowClass.count", 10 do
        WowClassImporter.import_all_classes
      end
      WowClass.all.each do |wow_class|
        assert_not_nil wow_class.name
        assert_not_nil wow_class.stat_multipliers("None", false)
        assert_not_nil wow_class.primary_armor_type
      end
    end
  end
end