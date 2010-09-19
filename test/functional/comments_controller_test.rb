require File.dirname(__FILE__) + '/../test_helper'

class CommentsControllerTest < ActionController::TestCase
  context "post create without login" do
    should "create a comment for a item" do
      item = Factory(:item)
      assert_no_difference "item.reload.comments.count" do
        post :create, :item_id => item.id
      end
      assert_response 302
    end
  end

  context "show" do
    should "create a comment for a item" do
      item = Factory(:comment, :comment => "zomg first post").commentable 
      get :show, :item_id => item.id
      assert_response :success
      assert_select ".comment", :text => "zomg first post"
    end
    
    should "not render layout" do
      item = Factory(:comment).commentable 
      get :show, :item_id => item.id
      assert_select "#header", :count => 0
    end

    should "paginate the comments" do
      item = Factory(:item)
      31.times{Factory(:comment, :commentable => item)}
      get :show, :item_id => item.id
      assert_select ".comment", :count => 30
      get :show, :item_id => item.id, :page => 2
      assert_select ".comment", :count => 1
    end
  end

  context "post create" do
    setup do
      activate_authlogic
      @user = Factory(:user)
    end
    
    should "create a comment for a item" do
      item = Factory(:item)
      assert_difference "item.reload.comments.count" do
        post :create, :item_id => item.id, :comment => {:comment => "hello there!"}
        assert_response :success
      end
    end

    should "belong to the logged in user" do
      item = Factory(:item)
      assert_difference "@user.reload.comments.count" do
        post :create, :item_id => item.id, :comment => {:comment => "hello there!"}
        assert_response :success
      end
    end

    should "not create comment with a validation error" do
      item = Factory(:item)
      assert_no_difference "item.reload.comments.count" do
        post :create, :item_id => item.id, :comment => {:comment => ""}
        assert_response :success
      end
    end

  end
end
