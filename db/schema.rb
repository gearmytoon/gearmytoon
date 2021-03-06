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

ActiveRecord::Schema.define(:version => 20100926160709) do

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

  create_table "characters", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "realm"
    t.integer  "wowarmory_gender_id"
    t.string   "gender"
    t.integer  "wowarmory_race_id"
    t.string   "race"
    t.integer  "wowarmory_class_id"
    t.string   "battle_group"
    t.integer  "level"
    t.text     "total_item_bonuses"
    t.string   "cached_slug"
    t.string   "locale"
    t.string   "status"
    t.string   "active_talent_point_distribution"
    t.decimal  "gmt_score",                        :precision => 10, :scale => 2
    t.integer  "guild_id"
    t.integer  "spec_id"
  end

  add_index "characters", ["name", "realm"], :name => "index_characters_on_name_and_realm"
  add_index "characters", ["name"], :name => "index_characters_on_name"
  add_index "characters", ["realm", "name"], :name => "index_characters_on_realm_and_name"

  create_table "comments", :force => true do |t|
    t.string   "title",            :limit => 50, :default => ""
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "containers", :force => true do |t|
    t.string   "name"
    t.integer  "wowarmory_container_id"
    t.integer  "area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "creatures", :force => true do |t|
    t.string   "name"
    t.integer  "area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "classification"
    t.string   "creature_type"
    t.integer  "wowarmory_creature_id"
    t.integer  "min_level"
    t.integer  "max_level"
  end

  create_table "guilds", :force => true do |t|
    t.string   "name"
    t.string   "faction"
    t.string   "realm"
    t.string   "locale"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_popularities", :force => true do |t|
    t.integer  "percentage",        :limit => 10, :precision => 10, :scale => 0
    t.integer  "item_id"
    t.integer  "average_gmt_score"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "spec_id"
  end

  create_table "item_sources", :force => true do |t|
    t.string   "type"
    t.integer  "arena_point_cost"
    t.integer  "honor_point_cost"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "drop_rate"
    t.integer  "creature_id"
    t.string   "trade_skill_id"
    t.integer  "quest_id"
    t.integer  "container_id"
  end

  add_index "item_sources", ["creature_id"], :name => "index_item_sources_on_creature_id"
  add_index "item_sources", ["item_id"], :name => "index_item_sources_on_item_id"
  add_index "item_sources", ["type"], :name => "index_item_sources_on_type"

  create_table "item_used_to_creates", :force => true do |t|
    t.integer  "wowarmory_item_id"
    t.integer  "item_source_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "item_used_to_creates", ["item_source_id"], :name => "index_item_used_to_creates_on_item_source_id"

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
    t.string   "restricted_to",                    :default => "NONE"
    t.string   "gem_color"
    t.text     "gem_sockets"
    t.text     "socket_bonuses"
    t.string   "type"
    t.string   "bonding"
    t.string   "side"
    t.integer  "item_level"
    t.integer  "required_level"
    t.text     "spell_effects"
    t.boolean  "heroic",                           :default => false
    t.integer  "opposing_sides_wowarmory_item_id"
    t.integer  "required_level_min"
    t.integer  "required_level_max"
    t.boolean  "account_bound"
    t.string   "cached_slug"
  end

  add_index "items", ["armor_type_id"], :name => "index_items_on_armor_type_id"
  add_index "items", ["bonding"], :name => "index_items_on_bonding"
  add_index "items", ["restricted_to"], :name => "index_items_on_restricted_to"
  add_index "items", ["slot"], :name => "index_items_on_slot"
  add_index "items", ["type"], :name => "index_items_on_type"
  add_index "items", ["wowarmory_item_id"], :name => "index_items_on_wowarmory_item_id"

  create_table "payments", :force => true do |t|
    t.integer  "purchaser_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "raw_data"
    t.string   "transaction_id"
    t.datetime "paid_until"
    t.string   "plan_type"
  end

  add_index "payments", ["transaction_id"], :name => "index_payments_on_transaction_id"

  create_table "quests", :force => true do |t|
    t.string   "name"
    t.integer  "wowarmory_quest_id"
    t.integer  "required_min_level"
    t.string   "suggested_party_size"
    t.integer  "level"
    t.integer  "area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "specs", :force => true do |t|
    t.integer  "wow_class_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "average_gmt_score"
    t.decimal  "gmt_score_standard_deviation", :precision => 10, :scale => 2
  end

  create_table "trade_skills", :force => true do |t|
    t.string   "wowarmory_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "upgrades", :force => true do |t|
    t.integer  "character_id"
    t.integer  "new_item_source_id"
    t.decimal  "dps_change",            :precision => 8, :scale => 2
    t.boolean  "for_pvp"
    t.text     "bonus_changes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "old_character_item_id"
    t.integer  "gem_one_id"
    t.integer  "gem_two_id"
    t.integer  "gem_three_id"
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
