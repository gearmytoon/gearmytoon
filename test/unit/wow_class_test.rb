require File.dirname(__FILE__) + '/../test_helper'

class WowClassTest < ActiveSupport::TestCase
  should "serialize stat_multipliers" do
    expected_stat_multipliers = {:a => 1}
    wow_class = Factory(:wow_class, :stat_multipliers => expected_stat_multipliers)
    assert_equal expected_stat_multipliers, wow_class.reload.stat_multipliers
  end
  context "associations" do
    should_belong_to :primary_armor_type
  end

end
