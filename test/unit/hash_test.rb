require File.dirname(__FILE__) + '/../test_helper'

class HashTest < ActiveSupport::TestCase
  context "map_to_hash" do
    should "map to another hash" do
      result = {:agility => 45}.map_to_hash{|k,v| [k,v*2]}
      assert_equal({:agility => 90}, result)
    end
  end
  
  context "add_values" do
    should "know how to add hashes with the same keys" do
      assert_equal({:agility => 100}, {:agility => 45}.add_values({:agility => 55}))
    end

    should "know how to add hashes with different keys" do
      assert_equal({:agility => 1, :stamina => 1}, {:agility => 1}.add_values({:stamina => 1}))
    end

    should "know how to add hashes if only one has a extra key" do
      assert_equal({:agility => 1, :stamina => 2}, {:stamina => 1}.add_values({:stamina => 1, :agility => 1}))
      assert_equal({:agility => 1, :stamina => 2}, {:agility => 1, :stamina => 1}.add_values({:stamina => 1}))
    end

    should "handle adding to nil hashes gracefully" do
      assert_equal({:stamina => 1}, {:stamina => 1}.add_values(nil))
    end
  end
  
  context "subtract_values" do
    should "know how to subtract hashes with the same keys" do
      assert_equal({:agility => -10}, {:agility => 45}.subtract_values({:agility => 55}))
    end

    should "know how to add hashes with different keys" do
      assert_equal({:agility => 1, :stamina => -1}, {:agility => 1}.subtract_values({:stamina => 1}))
    end

    should "know how to add hashes if only one has a extra key" do
      assert_equal({:agility => -1, :stamina => 0}, {:stamina => 1}.subtract_values({:stamina => 1, :agility => 1}))
      assert_equal({:agility => 1, :stamina => 0}, {:agility => 1, :stamina => 1}.subtract_values({:stamina => 1}))
    end

    should "handle adding to nil hashes gracefully" do
      assert_equal({:stamina => 1}, {:stamina => 1}.subtract_values(nil))
    end
  end
  
end
