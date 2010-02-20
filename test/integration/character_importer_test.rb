require File.dirname(__FILE__) + '/../test_helper'

class CharacterImporterTest < ActiveSupport::TestCase
  context "import_character_and_all_items" do
    should "import rails and all of his equipped items" do
      assert_difference "Item.count", 19 do
        assert_difference "Character.count" do
          CharacterImporter.import_character_and_all_items("Rails", "Baelgun")
        end
      end
    end
  end
end
