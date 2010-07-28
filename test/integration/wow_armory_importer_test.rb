require File.dirname(__FILE__) + '/../test_helper'

class WowArmoryImporterTest < ActiveSupport::TestCase
  should "foo" do
    WowArmoryImporter.import_from_wowarmory!(51902)
    
  end
end