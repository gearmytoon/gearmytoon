require File.dirname(__FILE__) + '/../test_helper'

class CreaturesControllerTest < ActionController::TestCase
  context "get show" do
    should "show creatures name" do
      creature = Factory(:creature, :name => "Kevin Sorbo")
      get :show, :id => creature.id
      assert_response :success
      assert_select ".creature .name", :text => "Kevin Sorbo"
    end
    
    should "show items dropped by" do
      creature = Factory(:creature)
      Factory(:dungeon_dropped_source, :creature => creature, :item => Factory(:item, :name => "Something"))
      get :show, :id => creature.id
      assert_select ".creature .item_dropped", :text => "Something"
    end
    
    should "show all items dropped by" do
      creature = Factory(:creature)
      2.times{Factory(:dungeon_dropped_source, :creature => creature)}
      get :show, :id => creature.id
      assert_select ".creature .item_dropped", :count => 2
    end

    should "show classification"
    should "show area found in"
    should "show other bosses in the same area if is a boss and in a raid/dungeon"
    
  end
end
