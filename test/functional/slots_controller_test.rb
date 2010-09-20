require File.dirname(__FILE__) + '/../test_helper'

class SlotsControllerTest < ActionController::TestCase
  context "get slot" do
    should "filter out desired slot" do
      trinket = Factory(:trinket, :name => "foo of awesomeness")
      helm = Factory(:item)
      spec = Factory(:survival_hunter_spec)
      Factory(:item_popularity, :spec => spec, :item => trinket)
      Factory(:item_popularity, :spec => spec, :item => helm)
      get :show, :spec_id => spec.id, :scope => spec.wow_class.id, :id => "Trinket"
      assert_response :success
      assert_select ".item_popularity .wow_item", :count => 1, :text => "foo of awesomeness"
    end
  end
end
