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
  setup do
    Factory(:raid_25)
    Factory(:raid_10)
    Factory(:dungeon)
  end
  
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  fixtures :all
  def assert_false(value)
    assert !value, "true is not false."
  end
  
  def freeze_time(frozen_time = nil)
    frozen_time = Time.now unless frozen_time
    Time.stubs(:now).returns(frozen_time)
    frozen_time
  end
  
  def assert_equivalent(expected, actual)
    assert expected.equivalent?(actual), "#{actual.join(",")} did not match expected: #{expected.join(",")}"
  end
  
end

class Net::HTTP
  alias_method :old_initialize, :initialize
  def initialize(*args)
    old_initialize(*args)
    @ssl_context = OpenSSL::SSL::SSLContext.new
    @ssl_context.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end
end
