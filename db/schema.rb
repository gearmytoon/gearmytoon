# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100328180713) do

  create_table "areas", :force => true do |t|
    t.string   "name"
    t.integer  "wowarmory_area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "difficulty"
  end

  add_index "areas", ["wowarmory_area_id"], :name => "index_areas_on_wowarmory_area_id"

  create_table "armor_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "character_items", :force => true do |t|
    t.integer  "character_id"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "character_items", ["character_id"], :name => "index_character_items_on_character_id"
  add_index "character_items", ["item_id"], :name => "index_character_items_on_item_id"

  create_table "characters", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "realm"
    t.integer  "wow_class_id"
    t.string   "primary_spec"
    t.integer  "wowarmory_gender_id"
    t.string   "gender"
    t.integer  "wowarmory_race_id"
    t.string   "race"
    t.integer  "wowarmory_class_id"
    t.string   "guild"
    t.string   "battle_group"
    t.string   "guild_url"
    t.integer  "level"
    t.text     "total_item_bonuses"
  end

  add_index "characters", ["name", "realm"], :name => "index_characters_on_name_and_realm"
  add_index "characters", ["name"], :name => "index_characters_on_name"
  add_index "characters", ["realm", "name"], :name => "index_characters_on_realm_and_name"
  add_index "characters", ["wow_class_id"], :name => "index_characters_on_wow_class_id"

  create_table "items", :force => true do |t|
    t.string   "name"
    t.integer  "wowarmory_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "inventory_type"
    t.integer  "quality"
    t.integer  "source_wowarmory_item_id"
    t.string   "icon"
    t.text     "bonuses"
    t.integer  "armor_type_id"
    t.integer  "token_cost"
    t.integer  "source_area_id"
  end

  add_index "items", ["armor_type_id"], :name => "index_items_on_armor_type_id"
  add_index "items", ["inventory_type"], :name => "index_items_on_inventory_type"
  add_index "items", ["source_area_id"], :name => "index_items_on_source_area_id"
  add_index "items", ["source_wowarmory_item_id"], :name => "index_items_on_source_wowarmory_item_id"
  add_index "items", ["wowarmory_item_id"], :name => "index_items_on_wowarmory_item_id"

  create_table "wow_classes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "primary_armor_type_id"
  end

  add_index "wow_classes", ["primary_armor_type_id"], :name => "index_wow_classes_on_primary_armor_type_id"

end
