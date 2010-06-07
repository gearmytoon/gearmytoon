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
      Resque.remove_queue('character_jobs')
    end

    should "not create more then one link between a user and a character" do
      assert_difference "@user.reload.characters.count" do
        post :create, :character => {:name => "Merb", :realm => "Baelgun", :locale => 'us'}
      end
      assert_no_difference "@user.reload.characters.count" do
        post :create, :character => {:name => "Merb", :realm => "Baelgun", :locale => 'us'}
      end
    end

    should "create a character refresh to track the status of the toon being reloaded" do
      assert_difference "CharacterRefresh.count" do
        post :create, :character => {:name => "Merb", :realm => "Baelgun", :locale => 'us'}
      end
    end

    should "create a resque job to refresh the toon" do
      assert_difference "Resque.size('character_jobs')" do
        post :create, :character => {:name => "Merb", :realm => "Baelgun", :locale => 'us'}
      end
    end

    should "not create a resque job for invalid toons" do
      assert_no_difference "Resque.size('character_jobs')" do
        post :create, :character => {:name => "", :realm => "Baelgun", :locale => 'us'}
      end
    end

    should "create a character if none exists" do
      assert_difference "Character.count" do
        post :create, :character => {:name => "Merb", :realm => "Baelgun", :locale => 'us'}
      end
    end

    should "not create a character if it already exists" do
      character = Factory(:character, :name => "Merb", :realm => "Baelgun", :locale => 'us')
      assert_no_difference "Character.count" do
        post :create, :character => {:name => "Merb", :realm => "Baelgun", :locale => 'us'}
      end
    end

    should "create a character if it isn't the first on a realm" do
      Factory(:character, :name => "Derb", :realm => "Baelgun")
      assert_difference "Character.count" do
        post :create, :character => {:name => "Merb", :realm => "Baelgun", :locale => 'us'}
      end
    end

    should "find a character if it exists and redirect show" do
      character = Factory(:character, :name => "Merb", :realm => "Thunderlord", :locale => 'us')
      post :create, :character => {:name => "Merb", :realm => "Thunderlord", :locale => 'us'}
      assert_redirected_to character_path(character)
    end

    should "not care about character names casing" do
      character = Factory(:character, :name => "Merb", :realm => "Lothar", :locale => 'us')
      post :create, :character => {:name => "mERb", :realm => "LOTHar", :locale => 'us'}
      assert_redirected_to character_path(character)
    end

    should "link to current_user" do
      assert_difference "@user.reload.characters.count" do
        post :create, :character => {:name => "Merb", :realm => "Lothar", :locale => 'us'}
      end
      assert @user.reload.characters.include?(assigns(:character))
    end

    should "create a character with a locale" do
      post :create, :character => {:name => 'Merb', :realm => 'Baelgun', :locale => 'us'}
      assert_equal 'us', assigns(:character).locale
    end
  end

  context "get show" do

    should "display the new character page for a new character being loaded" do
      character = Factory(:new_character)
      get :show, :id => character.friendly_id
      assert_template "characters/new_character.html.erb"
      assert_select "#new_toon"
    end

    should "display the no such character page if the character doesn't exist" do
      character = Factory(:does_not_exist_character)
      get :show, :id => character.friendly_id
      assert_redirected_to not_found_character_path(character)
    end

    should "display the buy this character if the character not paid for" do
      character = Factory(:unpaid_character)
      get :show, :id => character.friendly_id
      assert_select "#unpaid_character"
    end

    should "display the not support if this character is not level 80 and not paid for" do
      character = Factory(:unpaid_character, :level => 79)
      get :show, :id => character.friendly_id
      assert_select ".low_level"
    end

    should "display the not support if this character is not level 80 and is paid for" do
      character = Factory(:character, :level => 79)
      get :show, :id => character.friendly_id
      assert_select ".low_level"
    end

    should "refresh character info" do
      freeze_time(10.minutes.ago)
      character = Factory(:character)
      freeze_time(10.minutes.from_now)
      assert_difference "Resque.size('character_jobs')" do
        get :show, :id => character.friendly_id
      end
    end

    should "display character info" do
      character = Factory(:character, :name => "Merb", :realm => "Baelgun", :battle_group => "Shadowburn", :guild => "Special Circumstances", :primary_spec => "Survival")
      get :show, :id => character.friendly_id
      assert_response :success
      assert_select ".character .name", :text => "Merb"
      assert_select ".character .guild", :text => "Special Circumstances"
      assert_select ".character .level", :text => "80"
      assert_select ".character .klass", :text => "Hunter"
      assert_select ".character .realm", :text => "Baelgun"
      assert_select ".character .battlegroup", :text => "Shadowburn"
      assert_select ".character .spec", :text => "Survival"
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

    should "have links to all three upgrade sections" do
      character = Factory(:character_item).character
      Factory(:upgrade_from_emblem_of_frost, :character => character)
      Factory(:upgrade_from_emblem_of_triumph, :character => character)
      Factory(:upgrade_from_heroic_dungeon, :character => character)
      get :show, :id => character.friendly_id
      assert_select ".upgrade_summary_header a", :count => 3
    end

    should "show 3 upgrades under the frost emblem section" do
      character = Factory(:character_item).character
      3.times {Factory(:upgrade_from_emblem_of_frost, :character => character)}
      get :show, :id => character.friendly_id
      assert_select "#emblem_of_frost .upgrade", :count => 3
    end

    should "show how much the item costs" do
      character = Factory(:character_item).character
      item = Factory(:upgrade_from_emblem_of_frost, :character => character).new_item
      get :show, :id => character.friendly_id
      assert_select "#emblem_of_frost .upgrade .cost", :text => item.token_cost.to_s
    end

    should "show what you are upgrading from in the upgrade section" do
      character = Factory(:a_hunter)
      new_item_source = Factory(:triumph_emblem_source, :item => Factory(:item, :slot => "Head", :bonuses => {:attack_power => 400.0}))
      Factory(:upgrade, :character => character, :new_item_source => new_item_source, :old_item => Factory(:item, :name => "Stoppable Force", :slot => "Head", :bonuses => {:attack_power => 100.0}))
      get :show, :id => character.friendly_id
      assert_select "#emblem_of_triumph .upgrade .old_item", :text => "Stoppable Force"
    end

    should_eventually "not show old item if you did not have an item equipped before"
    
    should "show 3 upgrades under the triumph emblem section" do
      character = Factory(:character_item).character
      3.times {Factory(:upgrade_from_emblem_of_triumph, :character => character)}
      get :show, :id => character.friendly_id
      assert_select "#emblem_of_triumph .upgrade", :count => 3
    end

    should "show 3 upgrades and 3 sources under the heroic dungeon" do
      character = Factory(:character_item).character
      3.times {Factory(:upgrade_from_heroic_dungeon, :character => character)}
      get :show, :id => character.friendly_id
      assert_select "#heroic_dungeon .upgrade", :count => 3
      assert_select "#heroic_dungeon .source", :count => 3
    end

  end

  context "get pvp" do

    should "set cache headers" do
      character = Factory(:character)
      get :pvp, :id => character.friendly_id
      assert_equal character.reload.updated_at.utc.httpdate, @response.headers['Last-Modified']
      assert_equal "public, must-revalidate", @response.headers['Cache-Control']
    end

    should "refresh the toon if refresh was more then 5 minutes ago" do
      freeze_time(10.minutes.ago)
      character = Factory(:character)
      freeze_time(10.minutes.from_now)
      assert_difference "Resque.size('character_jobs')" do
        get :pvp, :id => character.friendly_id
      end
    end

    should "not refresh the toon if refresh was less then 5 minutes ago" do
      freeze_time(4.minutes.ago)
      character = Factory(:character)
      freeze_time(4.minutes.from_now)
      assert_no_difference "Resque.size('character_jobs')" do
        get :pvp, :id => character.friendly_id
      end
    end

    should "display the buy this character if the character not paid for" do
      character = Factory(:unpaid_character)
      get :pvp, :id => character.friendly_id
      assert_select "#unpaid_character"
    end

    should "have links to all three upgrade sections" do
      character = Factory(:character_item).character
      Factory(:upgrade_from_emblem_of_frost, :character => character)
      Factory(:upgrade_from_emblem_of_triumph, :character => character)
      Factory(:upgrade_from_wintergrasp_marks, :character => character)
      Factory(:upgrade_from_honor_points, :character => character)
      get :pvp, :id => character.friendly_id
      assert_select ".upgrade_summary_header a", :count => 4
    end

    should "display the not support if this character is not level 80" do
      character = Factory(:character, :level => 79)
      get :pvp, :id => character.friendly_id
      assert_select ".low_level"
    end

    context "upgrades sections" do
      should "render Honor" do
        character = Factory(:character_item, :item => Factory(:item, :bonuses => {:attack_power => 100.0})).character
        3.times{Factory(:upgrade_from_honor_points, :character => character)}
        get :pvp, :id => character.id
        assert_select "#honor_point"
        assert_select "#honor_point .upgrade", :count => 3
      end

      should "render Wintergrasp" do
        character = Factory(:character_item, :item => Factory(:item, :bonuses => {:attack_power => 100.0})).character
        3.times{Factory(:upgrade_from_wintergrasp_marks, :character => character)}
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
