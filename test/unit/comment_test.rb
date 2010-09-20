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
  
  context "default_scope" do
    should_eventually 'order by reverse date' do
      #fails when run units, i dunno why
      item = Factory(:item)
      first_comment = Factory(:comment, :commentable => item)
      sleep(2)
      second_comment = Factory(:comment, :commentable => item)
      assert_equal [second_comment, first_comment], item.reload.comments
    end
  end
end
