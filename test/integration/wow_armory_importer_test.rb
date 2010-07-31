require File.dirname(__FILE__) + '/../test_helper'

class WowArmoryImporterTest < ActiveSupport::TestCase
  # should "foo" do
  #   wi =  WowArmoryImporter.new(51902)
  #   pp wi.tooltip
  #   pp wi.info
  # end
  should "foo" do
    wi =  WowArmoryImporter.new(50638)
    pp (wi.info.at("item")['quality'])
  end
end