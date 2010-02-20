require File.dirname(__FILE__) + '/../test_helper'

class MaxDpsImporterTest < ActiveSupport::TestCase
  context "import_max_dps_for_item_slot" do
    should "import several items" do
      max_dps_importer = MaxDpsImporter.new
      assert_difference "Item.count", 30 do
        max_dps_importer.import_max_dps_for_item_slot(1)
      end
    end
  end
end
