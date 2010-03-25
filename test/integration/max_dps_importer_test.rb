require File.dirname(__FILE__) + '/../test_helper'

class MaxDpsImporterTest < ActiveSupport::TestCase
  context "import_max_dps_for_item_slot" do
    should "import several items" do
      hunter_items_file_path = "#{RAILS_ROOT}/test/fixtures/items/hunter.txt"
      File.delete(hunter_items_file_path) if File.exists?(hunter_items_file_path)
      max_dps_importer = MaxDpsImporter.new(:hunter)
      File.open(hunter_items_file_path, "w+") do |file|
        max_dps_importer.import_max_dps_for_item_slot(file,1)
      end
      items_importered = File.readlines(hunter_items_file_path)
      assert_equal items_importered.length, 30
    end
  end
end
