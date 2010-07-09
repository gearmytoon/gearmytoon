require File.dirname(__FILE__) + '/../test_helper'

class FindUpgradesJobTest < ActiveSupport::TestCase
  should "import a characters items" do
    character = Factory(:character, :name => "Merb", :realm => "Baelgun")
    character.refreshing!
    assert_difference "Item.count", 23 do
      FindUpgradesJob.perform(character.id)
    end
    assert_equal "geared", character.reload.status
  end
  
  should "know if the character does not exist" do
    character = Factory(:character, :name => "zzzzzzzzzzzzzMerb", :realm => "Baelgun")
    character.refreshing!
    FindUpgradesJob.perform(character.id)
    assert_equal "does_not_exist", character.reload.status
  end
  
end
