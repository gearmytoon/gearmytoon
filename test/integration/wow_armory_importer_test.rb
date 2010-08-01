require File.dirname(__FILE__) + '/../test_helper'

class WowArmoryImporterTest < ActiveSupport::TestCase

  should "get the tooltip" do
    wi =  WowArmoryImporter.new(50638)
    assert_not_nil wi.tooltip
  end

  should "get the info" do
    wi =  WowArmoryImporter.new(50638)
    assert_not_nil wi.info
  end

end