require File.dirname(__FILE__) + '/../test_helper'

class HomeControllerTest < ActionController::TestCase
  context "get show" do
    should "respond with success" do
      Factory(:character)
      get :show
      assert_response :success
    end

    should "set cache headers" do
      Factory(:character)
      get :show
      assert_equal "public, must-revalidate, max-age=86400", @response.headers['Cache-Control']
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
    should "set cache headers" do
      get :contact
      assert_equal "public, must-revalidate, max-age=86400", @response.headers['Cache-Control']
    end
    should "respond with success" do
      get :contact
      assert_response :success
    end
  end
  
  context "get class_spec_list" do
    should "not set cache headers" do
      get :class_spec_list
      assert_equal "private, max-age=0, must-revalidate", @response.headers['Cache-Control']
    end

    should "respond with success" do
      Factory(:marks_hunter_spec)
      get :class_spec_list
      assert_response :success
    end

    should "have a link to each spec under their class" do
      Factory(:survival_hunter_spec)
      Factory(:marks_hunter_spec)
      Factory(:enhance_shaman_spec)
      get :class_spec_list
      assert_select ".class_column", :count => 2
      assert_select ".class_column .class_name", :count => 2
      assert_select ".spec_entry", :count => 3
    end

    should "list each classes name and spec name" do
      Factory(:survival_hunter_spec)
      get :class_spec_list
      assert_select ".class_name", :text => "Hunter"
      assert_select ".spec_entry", :text => "Survival"
    end
  end
end
