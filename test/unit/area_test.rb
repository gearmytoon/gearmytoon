require 'test_helper'

class AreaTest < ActiveSupport::TestCase
  should "set the area name" do
    Area.destroy_all
    Area.create(:wowarmory_id => 206)
    assert_equal "Utgarde Keep", Area.first.name
  end
end
