require File.dirname(__FILE__) + '/../test_helper'

class CharactersControllerTest < ActionController::TestCase
  context "get show" do
    should "display character info" do
      get :show, :id => "merb"
      assert_response :success
      assert_select "#character_name", :text => "Merb"
    end
    should "have an upgrade section for emblems of frost" do
      get :show, :id => "merb"
      assert_select ".upgrade_section h1 .epic", :text => "Emblem of Frost"
    end
    
    should "show 3 upgrades under the frost emblem section" do
      get :show, :id => "merb"
      assert_select "#emblem_of_frost .upgrade", :count => 3
    end
    
    should "show 3 upgrades under the triumph emblem section" do
      get :show, :id => "merb"
      assert_select "#badge_of_triumph .upgrade", :count => 3
    end
    
    should "show 3 upgrades and 3 sources under the heroic dungeon" do
      get :show, :id => "merb"
      assert_select "#heroic_dungeon .upgrade", :count => 3
      assert_select "#heroic_dungeon .source", :count => 3
    end
    
  end
end
