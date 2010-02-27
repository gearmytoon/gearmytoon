require File.dirname(__FILE__) + '/../test_helper'

class CharactersControllerTest < ActionController::TestCase
  context "get index" do
    should "respond with success" do
      get :index
      assert_response :success
    end
  end

  context "post create" do
    should "find a character if it exists and redirect show" do
      character = Factory(:character, :name => "merb")
      post :create, :character => {:name => "merb"}
      assert_redirected_to character_path(character)
    end

    should "lookup character if it doesn't exist and redirect show" do
      assert_difference "Item.count", 19 do
        assert_difference "Character.count" do
          post :create, :character => {:name => "merb"}
        end
      end
      assert_redirected_to character_path(Character.last)
    end

  end

  context "get show" do
    should "display character info" do
      character = Factory(:character, :name => "merb")
      get :show, :id => character.id
      assert_response :success
      assert_select "#character_name", :text => "merb"
    end
    should "have an upgrade section for emblems of frost" do
      character = Factory(:character)
      get :show, :id => character.id
      assert_select ".upgrade_section h1 .epic", :text => "Emblem of Frost"
    end

    should "show 3 upgrades under the frost emblem section" do
      3.times {Factory(:item_from_emblem_of_frost)}
      character = Factory(:character)
      get :show, :id => character.id
      assert_select "#emblem_of_frost .upgrade", :count => 3
    end

    should_eventually "show how much the item costs" do
      character = Factory(:character)
      get :show, :id => character.id
      assert_select "#emblem_of_frost .upgrade .cost", :text => "60"
    end

    should "show what you are upgrade from in the upgrade section" do
      Factory(:item_from_emblem_of_triumph, :inventory_type => 2, :bonuses => {:attack_power => 400.0})
      character = Factory(:character_item, :item => Factory(:item, :name => "Stoppable Force", :inventory_type => 2, :bonuses => {:attack_power => 100.0}))
      get :show, :id => character.id
      assert_select "#emblem_of_triumph .upgrade .old_item", :text => "Stoppable Force"
    end

    should "not show old item if you did not have an item equipped before" do
      Factory(:item_from_emblem_of_triumph, :inventory_type => 2, :bonuses => {:attack_power => 400.0})
      character = Factory(:character)
      get :show, :id => character.id
      assert_select "#emblem_of_triumph .upgrade"
      assert_select "#emblem_of_triumph .upgrade .old_item", :text => "Empty Slot"
    end

    should "show 3 upgrades under the triumph emblem section" do
      3.times {Factory(:item_from_emblem_of_triumph)}
      character = Factory(:character)
      get :show, :id => character.id
      assert_select "#emblem_of_triumph .upgrade", :count => 3
    end

    should "show 3 upgrades and 3 sources under the heroic dungeon" do
      3.times {Factory(:item_from_heroic_dungeon)}
      character = Factory(:character)
      get :show, :id => character.id
      assert_select "#heroic_dungeon .upgrade", :count => 3
      assert_select "#heroic_dungeon .source", :count => 3
    end

  end
end

