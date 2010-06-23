require File.dirname(__FILE__) + '/../test_helper'

class ItemInfosControllerTest < ActionController::TestCase
  context "get show" do
    should "show base stats" do
      item = Factory(:item, :bonuses => {:agility => 1, :stamina => 1})
      get :show, :id => item.wowarmory_item_id
      assert_select ".base_stat", :text => "+1 Agility"
      assert_select ".base_stat", :text => "+1 Stamina"
    end
    
  end
end