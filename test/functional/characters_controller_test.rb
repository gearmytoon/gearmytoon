require File.dirname(__FILE__) + '/../test_helper'

class CharactersControllerTest < ActionController::TestCase
  test "show character" do
    get :show, :id => Factory(:character)
    assert_response :success
  end
end
