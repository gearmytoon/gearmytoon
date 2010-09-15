require File.dirname(__FILE__) + '/../test_helper'

class ItemsControllerTest < ActionController::TestCase
  context "get index" do
    should "not be available without Admin credentials" do
      get :index
      assert_redirected_to root_url
    end

    should "assign a list of alphabetically sorted items for Admin user" do
      activate_authlogic
      admin = Factory(:admin)
      session = UserSession.new(admin)
      session.id = :admin
      session.save
      get :index
      assert_equal Item.all(:order => :name), assigns(:items)
    end
  end

  context "get tooltip" do
    should "show base stats" do
      item = Factory(:item, :bonuses => {:agility => 1, :stamina => 1})
      get :tooltip, :id => item.id
      assert_select ".base_stat", :text => "+1 Agility"
      assert_select ".base_stat", :text => "+1 Stamina"
    end
    should "set cache headers" do
      item = Factory(:item, :bonuses => {:agility => 1, :stamina => 1})
      get :tooltip, :id => item.id
      assert_equal "max-age=10800, public", @response.headers['Cache-Control']
    end
  end

  context "get show" do
    should "set the page title" do
      item = Factory(:item, :name => "Epic Guitar")
      get :show, :id => item.id
      assert_equal "Epic Guitar", assigns(:title)
    end
    
    should "show the breakdown of who is using a item" do
      item = Factory(:item, :name => "Epic Guitar")
      spec = Factory(:survival_hunter_spec)
      Factory(:item_popularity, :spec => spec, :item => item, :percentage => 55, :average_gmt_score => 3451)
      get :show, :id => item.id
      assert_select ".item_popularity .percentage", :text => "55%"
      assert_select ".item_popularity .wow_class", :text => "Hunter"
      assert_select ".item_popularity .#{spec.css_icon_name}"
      assert_select ".item_popularity .average_gmt_score", :text => "3451"
    end

    should "set the meta description" do
      item = Factory(:item)
      get :show, :id => item.id
      assert_equal "#{item.name} is an epic mail belt for Rogues", assigns(:meta_tags)[:description]
    end

    should "show base stats" do
      item = Factory(:item, :bonuses => {:agility => 1, :stamina => 1})
      get :show, :id => item.id
      assert_select ".base_stat", :text => "+1 Agility"
      assert_select ".base_stat", :text => "+1 Stamina"
    end

    should "show spell on equip effects" do
      item = Factory(:item, :spell_effects => [{'trigger' => 1, :description => "Chance on melee or ranged critical strike to increase your armor penetration rating by 678 for 10 sec."}])
      get :show, :id => item.id
      assert_select ".spell_effect", :text => "Equip: Chance on melee or ranged critical strike to increase your armor penetration rating by 678 for 10 sec."
    end

    should "show spell on equip effects if the hash was made with strings instead of symbols" do
      item = Factory(:item, :spell_effects => [{'trigger' => 1, 'description' => "Chance on melee or ranged critical strike to increase your armor penetration rating by 678 for 10 sec."}])
      get :show, :id => item.id
      assert_select ".spell_effect", :text => "Equip: Chance on melee or ranged critical strike to increase your armor penetration rating by 678 for 10 sec."
    end

    should "show spell on use effects" do
      item = Factory(:item, :spell_effects => [{:trigger => 0, :description => "Chance on melee or ranged critical strike to increase your armor penetration rating by 678 for 10 sec."}])
      get :show, :id => item.id
      assert_select ".spell_effect", :text => "Use: Chance on melee or ranged critical strike to increase your armor penetration rating by 678 for 10 sec."
    end

    should "show created source items" do
      item_source = Factory(:created_source, :trade_skill => Factory(:trade_skill, :wowarmory_name => "trade_blacksmithing"))
      get :show, :id => item_source.item.id
      assert_select ".source", :text => "Blacksmithing"
    end

    should "show quest source items" do
      item_source = Factory(:quest_source, :quest => Factory(:quest, :name => "Foo Bar"))
      get :show, :id => item_source.item.id
      assert_select ".source", :text => "Reward from: Foo Bar"
    end

    should "show container source items" do
      item_source = Factory(:container_source, :container => Factory(:container, :name => "A Box", :area => Factory(:heroic_dungeon)))
      get :show, :id => item_source.item.id
      assert_select ".source", :text => "A Box in Heroic Super Fun Unicorn Land"
    end

    should "show where to get the dropped item from" do
      item_source = Factory(:dungeon_dropped_source, :creature => Factory(:dungeon_creature, :name => "Bob"))
      get :show, :id => item_source.item.id
      assert_select ".source", :text => "Bob in Super Fun Unicorn Land"
    end

    should "show where to get the arena points item from" do
      item_source = Factory(:arena_point_source, :vendor => Factory(:creature, :name => "Bob"))
      get :show, :id => item_source.item.id
      assert_select "abbr.arena[title='1,000 Arena Points']", :text => "1,000"
      assert_select "a.vendor", :text => "Bob"
    end

    should "show where to get the honor points item from" do
      item_source = Factory(:honor_point_source, :vendor => Factory(:creature, :name => "Moe"))
      get :show, :id => item_source.item.id
      assert_select "abbr.honor[title='45,000 Honor Points']", :text => "45,000"
      assert_select "a.vendor", :text => "Moe"
    end

    should "show which items are needed to purchase this item" do
      emblem = Factory(:item, :name => "Emblem of Frost")
      currency_item = Factory(:currency_item, :quantity => 60, :wowarmory_item_id => emblem.wowarmory_item_id, :item_source => Factory(:purchase_source, :vendor => Factory(:creature, :name => "Sam")))
      get :show, :id => currency_item.item_source.item.id
      assert_select "a.with_tooltip.currency_item[href=#{item_path(emblem)}]", :text => "60"
      assert_select "a.vendor", :text => "Sam"
    end

    context "ajax request" do
      should "show if a item is heroic" do
        item = Factory(:item, :heroic => true)
        xhr :get, :show, :id => item.id
        assert_select ".heroic", :text => "Heroic"
      end

      should "not show heroic if item is not heroic" do
        item = Factory(:item, :heroic => false)
        xhr :get, :show, :id => item.id
        assert_select ".heroic", :count => 0
      end

      should "show base stats" do
        item = Factory(:item, :bonuses => {:agility => 1, :stamina => 1})
        xhr :get, :show, :id => item.id
        assert_select ".base_stat", :text => "+1 Agility"
        assert_select ".base_stat", :text => "+1 Stamina"
      end

      should "not show armor type if it is miscelaneous" do
        item = Factory(:item, :armor_type => ArmorType.miscellaneous, :bonuses => {:agility => 1, :stamina => 1})
        xhr :get, :show, :id => item.id
        assert_select ".armor_type", :count => 0
      end

      should "show melee weapon info" do
        item = Factory(:item, :bonuses => {:melee_attack_speed => 3.5, :melee_min_damage => 200, :melee_max_damage => 300, :melee_dps => 100.0})
        xhr :get, :show, :id => item.id
        assert_select ".min_max_damage", :text => "200-300 Dmg"
        assert_select ".attack_speed", :text => "Speed 3.5"
        assert_select ".dps_description", :text => "(100.0 damage per second)"
      end

      should "show item level info" do
        item = Factory(:item, :item_level => 265, :required_level => 81)
        xhr :get, :show, :id => item.id
        assert_select ".required_level", :text => "Requires Level 81"
        assert_select ".item_level", :text => "Item Level 265"
      end

      should "show ranged weapon info" do
        item = Factory(:ranged_weapon, :bonuses => {:ranged_attack_speed => 3.5, :ranged_min_damage => 200, :ranged_max_damage => 300, :ranged_dps => 100.0})
        xhr :get, :show, :id => item.id
        assert_select ".min_max_damage", :text => "200-300 Dmg"
        assert_select ".attack_speed", :text => "Speed 3.5"
        assert_select ".dps_description", :text => "(100.0 damage per second)"
      end

      should "not show attack speed etc in the equipped stats section" do
        item = Factory(:item, :bonuses => {:ranged_attack_speed => 3.5, :ranged_min_damage => 200, :ranged_max_damage => 300, :ranged_dps => 100.0})
        xhr :get, :show, :id => item.id
        assert_select ".equip_stat", :count => 0
      end

      should "show equipped stats section" do
        item = Factory(:item, :bonuses => {:spell_power => 105, :mana_regen => 72})
        xhr :get, :show, :id => item.id
        assert_select ".equip_stat", :count => 2
        assert_select ".equip_stat", :text => "Equip: Increases your spell power by 105"
        assert_select ".equip_stat", :text => "Equip: Restores 72 mana per 5 secs"
      end

      should "show item name" do
        item = Factory(:item, :name => "Foo of Foo")
        xhr :get, :show, :id => item.id
        assert_select ".item_name", :text => "Foo of Foo"
      end

      should "show restricted to" do
        item = Factory(:item, :restricted_to => "Hunter")
        xhr :get, :show, :id => item.id
        assert_select ".restricted_to", :text => "Hunter"
      end

      should "not show restricted to NONE" do
        item = Factory(:item, :restricted_to => Item::RESTRICT_TO_NONE)
        xhr :get, :show, :id => item.id
        assert_select ".restricted_to", :count => 0
      end

      should "show item sockets" do
        item = Factory(:item, :gem_sockets => ["Meta", "Blue", "Red"], :socket_bonuses => {:agility => 4})
        xhr :get, :show, :id => item.id
        assert_select ".socket_meta", :text => "Meta Socket", :count => 1
        assert_select ".socket_blue", :text => "Blue Socket", :count => 1
        assert_select ".socket_red", :text => "Red Socket", :count => 1
        assert_select ".socket_bonuses", :text => "Socket Bonus: +4 Agility", :count => 1
      end

      should "show item slot name" do
        item = Factory(:item, :name => "Foo of Foo", :slot => "Helm")
        xhr :get, :show, :id => item.id
        assert_select ".item_slot", :text => "Helm"
        assert_select ".armor_type", :text => "Mail"
      end

      should "show item bonding" do
        item = Factory(:item, :name => "Foo of Foo", :slot => "Helm")
        xhr :get, :show, :id => item.id
        assert_select ".bonding", :text => "Binds when picked up"
      end

      should "show item armor" do
        item = Factory(:item, :bonuses => {:armor => 1})
        xhr :get, :show, :id => item.id
        assert_select ".armor", :text => "1 Armor"
      end

      should "not show item armor if there is none" do
        item = Factory(:item, :bonuses => {})
        xhr :get, :show, :id => item.id
        assert_select ".armor", :count => 0
      end
    end
  end
  
  context "post update_used_by" do
    setup do
      @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("#{ItemSummaryPoster::LOGIN}:#{ItemSummaryPoster::PASSWORD}")
    end
    should "create all used bys" do
      item = Factory(:item)
      spec = Factory(:spec, :name => "Survival", :wow_class => Hunter.first)
      assert_difference "item.reload.item_popularities.count" do
        assert_difference "spec.reload.item_popularities.count" do
          post :update_used_by, :id => item.wowarmory_item_id, :item_popularities => {"1" => {:average_gmt_score => 1, :percentage => 2, :spec_name => "Survival", :wow_class_name => "Hunter", :wowarmory_item_id => 33}}
          assert_response :success
        end
      end
    end

    should "create missing specs" do
      item = Factory(:item)
      assert_difference "Spec.count" do
        post :update_used_by, :id => item.wowarmory_item_id, :item_popularities => {"1" => {:average_gmt_score => 1, :percentage => 2, :spec_name => "Beast Mastery", :wow_class_name => "Hunter", :wowarmory_item_id => 33}}
        assert_response :success
      end
      assert_equal 1, item.item_popularities.size
      assert_equal "Beast Mastery", item.item_popularities.first.spec.name
      assert_equal "Hunter", item.item_popularities.first.wow_class.name
    end

    should "not orphan old item popularities" do
      spec = Factory(:spec, :name => "Survival", :wow_class => Hunter.first)
      item = Factory(:item_popularity, :spec => spec).item
      assert_difference "spec.reload.item_popularities.count", -1 do
        assert_difference "item.reload.item_popularities.count", -1 do
          post :update_used_by, :id => item.wowarmory_item_id, :item_popularities => {}
          assert_response :success
        end
      end
    end
    
    should "not error out if no item popularities given" do
      item = Factory(:item)
      post :update_used_by, :id => item.wowarmory_item_id
      assert_response :success
    end
    
    should "update item's updated_at time" do
      item = Factory(:item)
      old_updated_at = item.updated_at
      sleep(2)
      post :update_used_by, :id => item.wowarmory_item_id, :item_popularities => {}
      assert_not_equal item.reload.updated_at, old_updated_at
    end

    should "require correct basic authorization" do
      @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("empty:wtfbbq")
      item = Factory(:item)
      post :update_used_by, :id => item.wowarmory_item_id, :item_popularities => {}
      assert_response 401
    end

  end
  
end
