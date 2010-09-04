require File.dirname(__FILE__) + '/../test_helper'

class SpecTest < ActiveSupport::TestCase
  should "find create by names" do
    assert_difference "Spec.count" do
      Spec.find_or_create("Restoration", "Shaman")
    end
  end
  should "not create by names if already exists" do
    Spec.find_or_create("Restoration", "Shaman")
    assert_no_difference "Spec.count" do
      Spec.find_or_create("Restoration", "Shaman")
    end
  end
  should "create by name if doesn't exist for class" do
    WowClass.create_class!("Druid")
    Spec.find_or_create("Restoration", "Shaman")
    assert_difference "Spec.count" do
      Spec.find_or_create("Restoration", "Druid")
    end
  end
end
