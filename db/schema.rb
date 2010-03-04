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

ActiveRecord::Schema.define(:version => 20100304034042) do

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

  create_table "characters", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "realm"
    t.integer  "wow_class_id"
  end

  create_table "items", :force => true do |t|
    t.string   "name"
    t.integer  "wowarmory_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "inventory_type"
    t.integer  "quality"
    t.integer  "source_item_id"
    t.string   "icon"
    t.text     "bonuses"
    t.integer  "dungeon_id"
    t.integer  "armor_type_id"
    t.integer  "token_cost"
  end

  create_table "wow_classes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "stat_multipliers"
    t.integer  "primary_armor_type_id"
  end

end
