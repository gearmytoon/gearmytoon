require File.dirname(__FILE__) + '/../test_helper'

class CharacterImporterTest < ActiveSupport::TestCase
  context "refresh_character!" do
    should "refresh a characters updated_at time" do
      Factory(:wow_class, :name => "Paladin")
      character = Factory(:character, :name => "Rails", :realm => "Baelgun")
      CharacterImporter.import_character_and_all_items(character)
      first_updated = character.updated_at
      sleep 1
      assert_not_equal first_updated, CharacterImporter.import_character_and_all_items(character).updated_at
    end

    should "refresh a character" do
      Factory(:wow_class, :name => "Paladin")
      character = Factory.build(:character, :name => "Rails", :realm => "Baelgun")
      character = CharacterImporter.import_character_and_all_items(character)
      character.save!
      character.character_items.first.delete
      assert_no_difference "Item.count" do
        assert_difference "character.character_items.reload.count", 1 do
          CharacterImporter.refresh_character!(character)
        end
      end
    end
  end

  context "import_character_and_all_items" do
    should "import rails and all of his equipped items" do
      Factory(:wow_class, :name => "Paladin")
      character = Factory.build(:character, :name => "Rails", :realm => "Baelgun")
      assert_difference "Item.count", 28 do
        assert_difference "Character.count" do
          character = CharacterImporter.import_character_and_all_items(character)
          character.save!
        end
      end
      rails = Character.last
      assert_equal character, rails
      assert !rails.equipped_items.empty?
      assert_equal "Rails", rails.name
      assert_equal 80, rails.level
      assert_equal "Blood Elf", rails.race
      assert_equal 10, rails.wowarmory_race_id
      assert_equal "Male", rails.gender
      assert_equal 0, rails.wowarmory_gender_id
      assert_equal 2, rails.wowarmory_class_id
      assert_equal "Baelgun", rails.realm
      assert_equal "Shadowburn", rails.battle_group
      assert_equal "Blood on the Ground", rails.guild
      assert_equal "r=Baelgun&gn=Blood+on+the+Ground", rails.guild_url
      assert_equal "Paladin", rails.wow_class_name
      assert_equal "Protection", rails.primary_spec
    end

    should "import a characters items with the gems that are equipped" do
      Factory(:wow_class, :name => "Paladin")
      character = Factory(:new_character, :name => "Rails", :realm => "Baelgun")
      CharacterImporter.import(character)
      character.reload
      assert_equal 40032, character.character_item_on("Feet").first.gem_one.wowarmory_item_id
      assert_equal 41380, character.character_item_on("Helm").first.gem_one.wowarmory_item_id
      assert_equal 39976, character.character_item_on("Helm").first.gem_two.wowarmory_item_id
    end

    should_eventually "display a unable to fetch the latest data for your character, wow armory may be down"

    should "import a characters total_item_bonuses" do
      Factory(:wow_class, :name => "Hunter")
      character = Factory.build(:character, :name => "Merb", :realm => "Baelgun")
      CharacterImporter.import_character_and_all_items(character)
      assert_not_nil character.total_item_bonuses[:agility]
      assert_not_nil character.total_item_bonuses[:strength]
      assert_not_nil character.total_item_bonuses[:intellect]
      assert_not_nil character.total_item_bonuses[:stamina]
      assert_not_nil character.total_item_bonuses[:spirit]

      assert_not_nil character.total_item_bonuses[:armor]
      assert_not_nil character.total_item_bonuses[:defense]
      assert_not_nil character.total_item_bonuses[:dodge]
      assert_not_nil character.total_item_bonuses[:parry]
      assert_not_nil character.total_item_bonuses[:block]
      assert_not_nil character.total_item_bonuses[:resilience]

      assert_not_nil character.total_item_bonuses[:hit]
      assert_not_nil character.total_item_bonuses[:expertise]
      assert_not_nil character.total_item_bonuses[:attack_power]
      assert_not_nil character.total_item_bonuses[:haste]
      assert_not_nil character.total_item_bonuses[:crit]

      assert_not_nil character.total_item_bonuses[:mana_regen]
      assert_not_nil character.total_item_bonuses[:spell_power]
      assert_not_nil character.total_item_bonuses[:spell_penetration]

      assert_not_nil character.total_item_bonuses[:armor_penetration]
    end
  end
end
