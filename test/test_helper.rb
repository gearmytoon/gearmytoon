ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'authlogic/test_case'

class ActionController::TestCase
  include Authlogic::TestCase
  
  setup do
    Factory(:item, :wowarmory_item_id => Item::TRIUMPH_EMBLEM_ARMORY_ID)
    Factory(:item, :wowarmory_item_id => Item::FROST_EMBLEM_ARMORY_ID)
    Factory(:item, :wowarmory_item_id => Item::WINTERGRASP_MARK_OF_HONOR)
  end
end

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  fixtures :all
  def assert_false(value)
    assert !value, "true is not false."
  end
end
