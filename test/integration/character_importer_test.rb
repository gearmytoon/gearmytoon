require File.dirname(__FILE__) + '/../test_helper'

class CharacterImporterTest < ActiveSupport::TestCase
  context "refresh_character!" do
    setup do
      CharacterImporter.stubs(:find_or_import_item).returns(Factory(:item))
      CharacterImporter.stubs(:find_or_import_gem_item).returns(Factory(:red_gem))
    end
    
    should "import a characters active talent point distribution" do
      WowClass.create_class!("Paladin")
      character = Factory(:character, :name => "Rails", :realm => "Baelgun")
      CharacterImporter.refresh_character!(character)
      #rails active spec point dist
      assert_equal "003000000000000000000200000000000000000003203213211113012311", character.active_talent_point_distribution
    end

    should "import a character correctly" do
      WowClass.create_class!("Hunter")
      character = Factory(:character, :name => "Merb", :realm => "Baelgun", :locale => 'us')
      CharacterImporter.import_and_crawl_associated!(character.id)
      assert_equal "Beast Mastery", character.reload.spec.name
    end

    should "update a characters state to geared" do
      character = Factory(:character, :name => "Merb", :realm => "Baelgun")
      assert_equal "found", character.status
      CharacterImporter.refresh_character!(character)
      assert_equal "geared", character.status
    end

    should "import a hunters spec correctly" do
      character = Factory(:character, :name => "Merb", :realm => "Baelgun")
      CharacterImporter.refresh_character!(character)
      assert_equal "Beast Mastery", character.primary_spec
    end
    
    should "refresh a characters updated_at time" do
      WowClass.create_class!("Paladin")
      character = Factory(:character, :name => "Rails", :realm => "Baelgun")
      CharacterImporter.import_character_and_all_items(character)
      first_updated = character.updated_at
      sleep 1
      assert_not_equal first_updated, CharacterImporter.import_character_and_all_items(character).updated_at
    end

    should "refresh a character" do
      WowClass.create_class!("Paladin")
      character = Factory(:character, :name => "Rails", :realm => "Baelgun")
      character = CharacterImporter.import!(character)
      character.character_items.first.delete
      assert_no_difference "Item.count" do
        assert_difference "character.character_items.reload.count", 1 do
          CharacterImporter.refresh_character!(character)
        end
      end
    end

    should "calculate a characters total GMT points" do
      paladin = WowClass.create_class!("Paladin")
      character = Factory(:new_character, :name => "Rails", :realm => "Baelgun")
      CharacterImporter.import!(character)
      assert_equal "1844.58", character.reload.gmt_score.to_s
    end

    should "import a characters total_item_bonuses" do
      WowClass.create_class!("Hunter")
      character = Factory(:character, :name => "Merb", :realm => "Baelgun")
      CharacterImporter.import!(character)
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
