# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170323221743) do

  create_table "pairs", force: :cascade do |t|
    t.string  "first"
    t.string  "second"
    t.integer "switches",   default: 0
    t.integer "session_id"
    t.index ["session_id", "first", "second"], name: "index_pairs_on_session_id_and_first_and_second", unique: true
    t.index ["session_id"], name: "index_pairs_on_session_id"
  end

  create_table "players", force: :cascade do |t|
    t.string   "uuid"
    t.string   "name"
    t.text     "chords",     default: "--- []\n"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["name"], name: "index_players_on_name"
    t.index ["uuid"], name: "index_players_on_uuid", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.integer  "duration",   default: 1
    t.boolean  "complete",   default: false
    t.integer  "player_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["player_id"], name: "index_sessions_on_player_id"
  end

end
