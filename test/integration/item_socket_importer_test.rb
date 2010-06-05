require File.dirname(__FILE__) + '/../test_helper'

class ItemSocketImporterTest < ActiveSupport::TestCase
  should "import socket bonuses" do
    assert_equal "+9 Spell Power", ItemSocketImporter.new(50731).get_socket_bonuses
  end
end