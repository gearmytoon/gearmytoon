require File.dirname(__FILE__) + '/../test_helper'

class CharacterImporterTest < ActiveSupport::TestCase
  context "import" do
    setup do
      @character = Character.new(:name => "Merb", :realm => "Baelgun")
    end

    should "create a character if none exists" do
      assert_difference "Character.count" do
        CharacterImporter.import(@character)
      end
    end

    should "not create a character if it already exists" do
      character = Factory(:character, :name => "Merb", :realm => "Baelgun")
      assert_no_difference "Character.count" do
        CharacterImporter.import(character)
      end
    end

    should "create a character if it already exists on another realm" do
      character = Factory(:character, :name => "Merb", :realm => "Diablo")
      assert_difference "Character.count" do
        CharacterImporter.import(character)
      end
    end

    should "create a character if it already it isn't the first on a realm" do
      Factory(:character, :name => "Derb", :realm => "Diablo")
      character = Character.new(:name => "Merb", :realm => "Diablo")
      assert_difference "Character.count" do
        CharacterImporter.import(character)
      end
    end
  end
end
