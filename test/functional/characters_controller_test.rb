require File.dirname(__FILE__) + '/../test_helper'
class CharactersControllerTest < ActionController::TestCase
  context "get #index" do
    should "not be visible to a normal user" do
      activate_authlogic
      Factory(:user)
      get :index
      assert_redirected_to root_url
    end
  end
  context "post create" do
    setup do
      activate_authlogic
      @user = Factory(:user)
      Character.any_instance.stubs(:import_items_from_wow_armory)
    end

    should "create a character if none exists" do
      assert_difference "Character.count" do
        post :create, :character => {:name => "Merb", :realm => "Baelgun"}
      end
    end

    should "not create a character if it already exists" do
      character = Factory(:character, :name => "Merb", :realm => "Baelgun")
      assert_no_difference "Character.count" do
        post :create, :character => {:name => "Merb", :realm => "Baelgun"}
      end
    end

    should "create a character if it isn't the first on a realm" do
      Factory(:character, :name => "Derb", :realm => "Baelgun")
      assert_difference "Character.count" do
        post :create, :character => {:name => "Merb", :realm => "Baelgun"}
      end
    end

    should "find a character if it exists and redirect show" do
      character = Factory(:character, :name => "Merb", :realm => "Thunderlord")
      post :create, :character => {:name => "merb", :realm => "Thunderlord"}
      assert_redirected_to character_path(character)
    end

    should "not care about character names casing" do
      character = Factory(:character, :name => "Merb", :realm => "Lothar")
      post :create, :character => {:name => "mERb", :realm => "LOTHar"}
      assert_redirected_to character_path(character)
    end

    should "link to current_user" do
      post :create, :character => {:name => "Merb", :realm => "Lothar"}
      assert_equal @user, assigns(:character).user
    end
  end

  context "get show" do
    setup do
      CharacterImporter.stubs(:refresh_character!)
    end
    should "refresh character info" do
      character = Factory(:character)
      #mocha wasn't evaluating "expects"
      CharacterImporter.expects(:refresh_character!).raises("wtf")
      assert_raises RuntimeError, "wtf" do
        get :show, :id => character.id
      end
    end
    should "display character info" do
      character = Factory(:character, :name => "merb", :realm => "Baelgun", :battle_group => "Shadowburn", :guild => "Special Circumstances", :primary_spec => "Survival")
      get :show, :id => character.id
      assert_response :success
      assert_select "#character_name", :text => "Merb"
      assert_select "#character_info .guild", :text => "&lt;Special Circumstances&gt;"
      assert_select "#character_info .level", :text => "80"
      assert_select "#character_info .klass", :text => "Hunter"
      assert_select "#realm_and_battlegroup", :text => "Baelgun, Shadowburn"
      assert_select "#character_info .primary_spec", :text => "Survival"
    end

    should "find a character by slug" do
      character = Factory(:character, :name => "Foo", :realm => "Bar")
      get :show, :id => character.friendly_id
      assert_response :success
      assert_equal character, assigns(:character)
    end

    #broke with the quality string upgrade
    should_eventually "have an upgrade section for emblems of frost" do
      Factory(:item_from_emblem_of_frost)
      character = Factory(:character)
      get :show, :id => character.id
      assert_select ".upgrade_section h1 .epic", :text => "Emblem of Frost"
    end

    should "show 3 upgrades under the frost emblem section" do
      3.times {Factory(:item_from_emblem_of_frost)}
      character = Factory(:character_item).character
      get :show, :id => character.id
      assert_select "#emblem_of_frost .upgrade", :count => 3
    end

    should "show how much the item costs" do
      item = Factory(:item_from_emblem_of_frost)
      character = Factory(:character_item).character
      get :show, :id => character.id
      assert_select "#emblem_of_frost .upgrade .cost", :text => item.token_cost.to_s
    end

    should "show what you are upgrading from in the upgrade section" do
      Factory(:item_from_emblem_of_triumph, :slot => "Head", :bonuses => {:attack_power => 400.0})
      character_item = Factory(:character_item, :item => Factory(:item, :name => "Stoppable Force", :slot => "Head", :bonuses => {:attack_power => 100.0}))
      get :show, :id => character_item.character.id
      assert_select "#emblem_of_triumph .upgrade .old_item", :text => "Stoppable Force"
    end

    should_eventually "not show old item if you did not have an item equipped before" do
      Factory(:item_from_emblem_of_triumph, :slot => "Head", :bonuses => {:attack_power => 400.0})
      character = Factory(:character)
      get :show, :id => character.id
      assert_select "#emblem_of_triumph .upgrade"
      assert_select "#emblem_of_triumph .upgrade .old_item", :text => "Empty Slot"
    end

    should "show 3 upgrades under the triumph emblem section" do
      3.times {Factory(:item_from_emblem_of_triumph)}
      character = Factory(:character_item).character
      get :show, :id => character.id
      assert_select "#emblem_of_triumph .upgrade", :count => 3
    end

    should "show 3 upgrades and 3 sources under the heroic dungeon" do
      3.times {Factory(:item_from_heroic_dungeon)}
      character = Factory(:character_item).character
      get :show, :id => character.id
      assert_select "#heroic_dungeon .upgrade", :count => 3
      assert_select "#heroic_dungeon .source", :count => 3
    end

  end

  context "get pvp" do
    
    context "upgrades sections" do
      should "render Honor" do
        character = Factory(:character_item, :item => Factory(:item, :bonuses => {:attack_power => 100.0})).character
        3.times{Factory(:item_from_honor_points)}
        get :pvp, :id => character.id
        assert_select "#honor_points"
        assert_select "#honor_points .upgrade", :count => 3
      end

      should "render Wintergrasp" do
        character = Factory(:character_item, :item => Factory(:item, :bonuses => {:attack_power => 100.0})).character
        3.times{Factory(:item_from_wintergrasp_marks)}
        get :pvp, :id => character.id
        assert_select "#wintergrasp_mark_of_honor"
        assert_select "#wintergrasp_mark_of_honor .upgrade", :count => 3
      end

      should "render Triumph" do
        character = Factory(:character)
        get :pvp, :id => character.id
        assert_select "#emblem_of_triumph"
      end

      should "render Arena" do
        character = Factory(:character)
        get :pvp, :id => character.id
        assert_select "#arena_points"
      end

      should "render Frost" do
        character = Factory(:character)
        get :pvp, :id => character.id
        assert_select "#emblem_of_frost"
      end
    end
  end
end
