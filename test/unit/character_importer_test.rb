require File.dirname(__FILE__) + '/../test_helper'

class CharacterImporterTest < ActiveSupport::TestCase
  context "import" do
    should "create a character if none exists" do
      assert_difference "Character.count" do
        CharacterImporter.import("Merb", "Baelgun")
      end
    end

    should "not create a character if it already exists" do
      Factory(:character, :name => "Merb", :realm => "Baelgun")
      assert_no_difference "Character.count" do
        CharacterImporter.import("Merb", "Baelgun")
      end
    end

    should "create a character if it already exists on another realm" do
      Factory(:character, :name => "Merb", :realm => "Diablo")
      assert_difference "Character.count" do
        CharacterImporter.import("Merb", "Baelgun")
      end
    end

    should "create a character if it already it isn't the first on a realm" do
      Factory(:character, :name => "Derb", :realm => "Diablo")
      assert_difference "Character.count" do
        CharacterImporter.import("Merb", "Diablo")
      end
    end

  end
end