require File.dirname(__FILE__) + '/../test_helper'

class CommentTest < ActiveSupport::TestCase
  context "validations" do
    should 'validate precense of user' do
      assert_false Factory.build(:comment, :user => nil).valid?
    end
    should 'validate precense of comment text' do
      assert_false Factory.build(:comment, :comment => nil).valid?
    end
    should 'validate length of comment text' do
      assert_false Factory.build(:comment, :comment => "1").valid?
      assert Factory.build(:comment, :comment => "12").valid?
    end
    should 'validate precense of commentable' do
      assert_false Factory.build(:comment, :commentable => nil).valid?
    end
    should 'create valid comment' do
      assert Factory.build(:comment).valid?
    end
  end
end
