require File.dirname(__FILE__) + '/../test_helper'

class ArmorTypeTest < ActiveSupport::TestCase
  context "associations" do
    should_have_many :items
    should_have_many :wow_classes
  end
  context "armor types" do
    should "not create dupes" do
      ArmorType.plate
      assert_no_difference "ArmorType.count" do
        ArmorType.plate
      end
    end
    should "define method for armor types" do
      assert ArmorType.fist_weapon
      assert ArmorType.leather
      assert ArmorType.cloth
      assert ArmorType.plate
      assert ArmorType.mail
      assert ArmorType.sword
      assert ArmorType.mace
      assert ArmorType.staff
      assert ArmorType.wand
    end
  end
end
