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

    should "save referer" do
      item = Factory(:item)
      referer = "http://localhost:3000/items/#{item.id}"
      @request.env["HTTP_REFERER"] = referer
      assert_no_difference "item.reload.comments.count" do
        post :create, :item_id => item.id
      end
      assert_equal referer, session[:return_to]
      assert_response 302
    end

    should "save user request url if referer is nil" do
      item = Factory(:item)
      @request.env["HTTP_REFERER"] = nil
      assert_no_difference "item.reload.comments.count" do
        post :create, :item_id => item.id
      end
      assert_equal "/items/#{item.id}/comments", session[:return_to]
      assert_response 302
    end

  end

  context "show" do
    should "set cache headers" do
      item = Factory(:comment, :comment => "zomg first post").commentable 
      get :show, :item_id => item.id
      assert_response :success
      assert_not_nil @response.headers['ETag']
      assert_equal 'public, must-revalidate', @response.headers['Cache-Control']
    end

    should "not change etag when there is no new comment" do
      item = Factory(:comment, :comment => "zomg first post").commentable 
      get :show, :item_id => item.id
      old_etag = @response.headers['ETag']
      get :show, :item_id => item.id
      assert_equal old_etag, @response.headers['ETag']
    end

    should "change etag when there is a new comment" do
      item = Factory(:comment, :comment => "zomg first post").commentable 
      get :show, :item_id => item.id
      old_etag = @response.headers['ETag']
      Factory(:comment, :comment => "second post", :commentable => item)
      get :show, :item_id => item.id
      assert_not_equal old_etag, @response.headers['ETag']
    end

    should "return not modified if the etag hasn't changed" do
      item = Factory(:comment, :comment => "zomg first post").commentable 
      get :show, :item_id => item.id
      @request.env["HTTP_IF_NONE_MATCH"] = @response.headers['ETag']
      get :show, :item_id => item.id
      assert_response :not_modified
    end

    should "show a comments text" do
      item = Factory(:comment, :comment => "zomg first post").commentable 
      get :show, :item_id => item.id
      assert_response :success
      assert_select ".comment_text", :text => "zomg first post"
    end

    should "html escape a comment" do
      item = Factory(:comment, :comment => "<script>alert('hacked');</script>").commentable 
      get :show, :item_id => item.id
      assert_response :success
      assert_select ".comment_text", :text => "&lt;script&gt;alert('hacked');&lt;/script&gt;"
    end

    should "show a commenters name" do
      item = Factory(:comment, :user => Factory(:user, :name => "some guy")).commentable 
      get :show, :item_id => item.id
      assert_response :success
      assert_select ".commenter", :text => "some guy"
    end

    should "show when a comment was posted" do
      freeze_time(1.minute.ago)
      item = Factory(:comment).commentable 
      freeze_time(1.minute.from_now)
      get :show, :item_id => item.id
      assert_response :success
      assert_select ".posted_at", :text => "1 minute ago"
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
      end
    end

    should "belong to the logged in user" do
      item = Factory(:item)
      assert_difference "@user.reload.comments.count" do
        post :create, :item_id => item.id, :comment => {:comment => "hello there!"}
      end
    end

    should "not create comment with a validation error" do
      item = Factory(:item)
      assert_no_difference "item.reload.comments.count" do
        post :create, :item_id => item.id, :comment => {:comment => ""}
      end
    end

    should "redirect to items page" do
      item = Factory(:item)
      assert_difference "@user.reload.comments.count" do
        post :create, :item_id => item.id, :comment => {:comment => "first post"}
        assert_redirected_to item_path(item)
      end
    end

  end
end
