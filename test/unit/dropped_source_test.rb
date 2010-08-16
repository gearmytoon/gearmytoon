require File.dirname(__FILE__) + '/../test_helper'

class DroppedSourceTest < ActiveSupport::TestCase
  context "associations" do
    should_belong_to :creature
  end
end
