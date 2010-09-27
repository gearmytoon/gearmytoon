require File.dirname(__FILE__) + '/../test_helper'

class CreatureTest < ActiveSupport::TestCase
  context "humanize_classification" do
    should "return normal for 0" do
      assert_equal "Normal", Factory.build(:creature, :classification => "0").humanize_classification
    end
    should "return elite for 1" do
      assert_equal "Elite", Factory.build(:creature, :classification => "1").humanize_classification
    end
    should "return rare elite for 2" do
      assert_equal "Rare Elite", Factory.build(:creature, :classification => "2").humanize_classification
    end
    should "return boss for 3" do
      assert_equal "Boss", Factory.build(:creature, :classification => "3").humanize_classification
    end
  end
end
