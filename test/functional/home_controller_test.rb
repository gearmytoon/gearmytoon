require File.dirname(__FILE__) + '/../test_helper'

class HomeControllerTest < ActionController::TestCase
  context "get index" do
    should "respond with success" do
      Factory(:character)
      get :show
      assert_response :success
    end

    should "assign four characters" do
      6.times {|i| Factory(:character, :name => "Foo#{i}") }
      get :show
      assert_equal Character.all(:limit => 4), assigns(:characters)
    end
  end

  context "get contact" do
    should "respond with success" do
      get :contact
      assert_response :success
    end
  end
end
