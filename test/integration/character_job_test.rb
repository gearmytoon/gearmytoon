require File.dirname(__FILE__) + '/../test_helper'

class CharacterJobTest < ActiveSupport::TestCase

  should "import a characters items" do
    character = Factory(:character, :name => "Merb", :realm => "Baelgun")
    assert_difference "Item.count", 18 do
      CharacterJob.perform(character.id)
    end
  end

end
