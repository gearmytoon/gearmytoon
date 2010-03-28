require File.dirname(__FILE__) + '/../test_helper'

class CharactersControllerTest < ActionController::TestCase
  context "post create" do
    should "lookup character if it doesn't exist and redirect show" do
      assert_difference "Item.count", 19 do
        assert_difference "Character.count" do
          post :create, :character => {:name => "Merb", :realm => "Baelgun"}
        end
      end
      assert_redirected_to character_path(Character.last)
    end
  end
  
end
