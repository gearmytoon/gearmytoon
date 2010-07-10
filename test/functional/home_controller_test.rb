require File.dirname(__FILE__) + '/../test_helper'

class HomeControllerTest < ActionController::TestCase
  context "get index" do
    should "respond with success" do
      Factory(:character)
      get :show
      assert_response :success
    end

    should "assign four level 80 geared characters" do
      valid_characters = []
      4.times do |i|
        c = Factory(:character, :name => "Foo#{i}", :level => 80)
        c.found_upgrades!
        valid_characters << c
        Factory(:character, :name => "Foo#{i+100}", :level => 70)
        Factory(:does_not_exist_character, :name => "Foo#{i+200}")
      end
      get :show
      assert_equal valid_characters, assigns(:characters)
    end
  end

  context "get contact" do
    should "respond with success" do
      get :contact
      assert_response :success
    end
  end
end
