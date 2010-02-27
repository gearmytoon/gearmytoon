require File.dirname(__FILE__) + '/../test_helper'

class ArmorTypeTest < ActiveSupport::TestCase
  context "associations" do
    should_have_many :items
    should_have_many :wow_classes
  end
end
