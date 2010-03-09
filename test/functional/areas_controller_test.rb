require 'test_helper'

class AreasControllerTest < ActionController::TestCase
  context "GET index" do
    setup { get :index }

    should_respond_with :success
    should_assign_to :areas
  end

  context "GET show" do
    setup do
      area = Factory(:area)
      get :show, :id => area.id
    end

    should_respond_with :success
    should_assign_to :area
  end

  context "GET new" do
    setup { get :new }

    should_respond_with :success
    should_assign_to :area
  end

  context "GET edit" do
    setup do
      area = Factory(:area)
      get :edit, :id => area.id
    end

    should_respond_with :success
    should_assign_to :area
  end

  context "POST create" do
    context "regular area" do
      setup do
        post :create, :area => {:name => "Lol Town", :wowarmory_id => 1234}
      end

      should_respond_with :redirect
      should_set_the_flash_to "Area created successfully"
    end

    context "Dungeon" do
      setup do
        Dungeon.destroy_all
        post :create, :area => {:name => "Dungeon 5000", :wowarmory_id => 4821, :type => 'Dungeon'}
      end

      should_respond_with :redirect
      should_set_the_flash_to "Dungeon created successfully"

      should "create a Dungeon" do
        assert_equal 1, Dungeon.count
      end
    end

    context "Raid" do
      setup do
        Raid.destroy_all
        post :create, :area => {:name => "Raid 5000", :wowarmory_id => 4801, :type => 'Raid'}
      end

      should_respond_with :redirect
      should_set_the_flash_to "Raid created successfully"

      should "create a Raid" do
        assert_equal 1, Raid.count
      end
    end

    context "Invalid Area Type" do
      setup do
        post :create, :area => {:name => "Raid 5000", :wowarmory_id => 4801, :type => 'HackedU'}
      end

      should_respond_with :redirect
    end
  end

  context "POST update" do
    setup do
      @area = Factory(:area)
      post :update, :id => @area.id, :area => {:name => "Lol Town", :wowarmory_id => 1234}
    end

    should_respond_with :redirect
    should_set_the_flash_to "Area updated successfully"

    should "set the new values" do
      area = Area.find(@area.id)
      assert_equal "Lol Town", area.name
      assert_equal 1234, area.wowarmory_id
    end
  end
end
