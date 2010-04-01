require File.dirname(__FILE__) + '/../test_helper'

class CharactersControllerTest < ActionController::TestCase
  context "post create" do
    should "lookup character if it doesn't exist and redirect show" do
      assert_difference "Item.count", 19 do
        assert_difference "Character.count" do
          activate_authlogic
          Factory(:user)
          post :create, :character => {:name => "Merb", :realm => "Baelgun"}
          assert_redirected_to character_path(Character.last)
        end
      end
    end

    should_eventually "display no such character page if we cannot find the character" do
      post :create, :character => {:name => "zzzzzzzzzzerb", :realm => "Thunderlord"}
      assert_redirected_to no_such_character_home_path(:name => "Zzzzzzzzzzerb", :realm => "Thunderlord")
    end
  end

end
