require File.dirname(__FILE__) + '/../test_helper'

class FindCharacterJobTest < ActiveSupport::TestCase

  should "import a characters items" do
    character = Factory(:new_character, :name => "Merb", :realm => "Baelgun")
    character.refreshing!
    assert_difference "Item.count", 23 do
      FindCharacterJob.perform(character.id)
    end
    assert_equal "geared", character.reload.status
  end
  
  should "know if the character does not exist" do
    character = Factory(:new_character, :name => "zzzzzzzzzzzzzMerb", :realm => "Baelgun", :wow_class => nil)
    character.refreshing!
    FindCharacterJob.perform(character.id)
    assert_equal "does_not_exist", character.reload.status
  end
  
end
