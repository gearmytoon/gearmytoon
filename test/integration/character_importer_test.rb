require File.dirname(__FILE__) + '/../test_helper'

class CharacterImporterTest < ActiveSupport::TestCase
  context "import_character_and_all_items" do
    should "import merb and all of his equipped items" do
      assert_difference "Character.count" do
        CharacterImporter.import_character_and_all_items("Merb", "Baelgun")
      end
    end
  end
end
