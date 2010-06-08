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

ActiveRecord::Schema.define(:version => 20100608145457) do

  create_table "areas", :force => true do |t|
    t.string   "name"
    t.integer  "wowarmory_area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "difficulty"
    t.integer  "players"
  end

  add_index "areas", ["wowarmory_area_id"], :name => "index_areas_on_wowarmory_area_id"

  create_table "armor_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "beta_participants", :force => true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "character_items", :force => true do |t|
    t.integer  "character_id"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "gem_one_id"
    t.integer  "gem_two_id"
    t.integer  "gem_three_id"
  end

  add_index "character_items", ["character_id"], :name => "index_character_items_on_character_id"
  add_index "character_items", ["item_id"], :name => "index_character_items_on_item_id"

  create_table "character_refreshes", :force => true do |t|
    t.integer  "character_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.string   "cached_slug"
    t.string   "locale"
    t.string   "status"
  end

  add_index "characters", ["name", "realm"], :name => "index_characters_on_name_and_realm"
  add_index "characters", ["name"], :name => "index_characters_on_name"
  add_index "characters", ["realm", "name"], :name => "index_characters_on_realm_and_name"
  add_index "characters", ["wow_class_id"], :name => "index_characters_on_wow_class_id"

  create_table "item_sources", :force => true do |t|
    t.string   "type"
    t.integer  "arena_point_cost"
    t.integer  "honor_point_cost"
    t.integer  "wowarmory_token_item_id"
    t.integer  "token_cost"
    t.integer  "source_area_id"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "item_sources", ["item_id"], :name => "index_item_sources_on_item_id"
  add_index "item_sources", ["source_area_id"], :name => "index_item_sources_on_source_area_id"
  add_index "item_sources", ["type"], :name => "index_item_sources_on_type"
  add_index "item_sources", ["wowarmory_token_item_id"], :name => "index_item_sources_on_wowarmory_token_item_id"

  create_table "items", :force => true do |t|
    t.string   "name"
    t.integer  "wowarmory_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "icon"
    t.text     "bonuses"
    t.integer  "armor_type_id"
    t.string   "quality"
    t.string   "slot"
    t.string   "restricted_to",     :default => "NONE"
    t.string   "gem_color"
    t.text     "gem_sockets"
    t.text     "socket_bonuses"
  end

  add_index "items", ["armor_type_id"], :name => "index_items_on_armor_type_id"
  add_index "items", ["restricted_to"], :name => "index_items_on_restricted_to"
  add_index "items", ["slot"], :name => "index_items_on_slot"
  add_index "items", ["wowarmory_item_id"], :name => "index_items_on_wowarmory_item_id"

  create_table "payments", :force => true do |t|
    t.string   "recipient_token"
    t.string   "caller_reference"
    t.integer  "purchaser_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "caller_token"
    t.datetime "paid_at"
  end

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "upgrades", :force => true do |t|
    t.integer  "character_id"
    t.integer  "new_item_source_id"
    t.decimal  "dps_change",            :precision => 8, :scale => 2
    t.boolean  "for_pvp"
    t.text     "bonus_changes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "old_character_item_id"
  end

  add_index "upgrades", ["character_id", "new_item_source_id"], :name => "index_upgrades_on_character_id_and_new_item_source_id"
  add_index "upgrades", ["character_id"], :name => "index_upgrades_on_character_id"
  add_index "upgrades", ["new_item_source_id"], :name => "index_upgrades_on_new_item_source_id"

  create_table "user_characters", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "subscriber_id"
    t.integer  "character_id"
  end

  add_index "user_characters", ["character_id"], :name => "index_user_characters_on_character_id"
  add_index "user_characters", ["subscriber_id"], :name => "index_user_characters_on_subscriber_id"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "crypted_password",  :null => false
    t.string   "password_salt",     :null => false
    t.string   "persistence_token", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "identity_url"
    t.boolean  "admin"
    t.boolean  "free_access"
    t.string   "name"
  end

  create_table "wow_classes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "primary_armor_type_id"
    t.string   "type"
  end

  add_index "wow_classes", ["name"], :name => "index_wow_classes_on_name"
  add_index "wow_classes", ["primary_armor_type_id"], :name => "index_wow_classes_on_primary_armor_type_id"
  add_index "wow_classes", ["type"], :name => "index_wow_classes_on_type"

end
