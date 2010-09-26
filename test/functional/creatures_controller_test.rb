require File.dirname(__FILE__) + '/../test_helper'

class CreaturesControllerTest < ActionController::TestCase
  context "get show" do
    should "show creatures name" do
      creature = Factory(:creature, :name => "Kevin Sorbo")
      get :show, :id => creature.id
      assert_response :success
      assert_select ".creature .name", :text => "Kevin Sorbo"
    end
  end
end
