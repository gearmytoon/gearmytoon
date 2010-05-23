require File.dirname(__FILE__) + '/../test_helper'

class CharactersControllerTest < ActionController::TestCase
  setup :activate_authlogic

  context "post create" do
    setup do
      Resque.remove_queue('character_jobs')
    end

    should "lookup character if it doesn't exist and redirect show" do
      assert_difference "Item.count", 18 do
        assert_difference "Character.count" do
          Factory(:user)
          post :create, :character => {:name => "Merb", :realm => "Baelgun"}
          Resque.reserve('character_jobs').perform
          assert_redirected_to character_path(Character.last)
        end
      end
    end

  end
end
