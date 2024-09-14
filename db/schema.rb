# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2017_03_23_221743) do
  create_table "pairs", force: :cascade do |t|
    t.string "first"
    t.string "second"
    t.integer "switches", default: 0
    t.integer "session_id"
    t.index ["session_id", "first", "second"], name: "index_pairs_on_session_id_and_first_and_second", unique: true
    t.index ["session_id"], name: "index_pairs_on_session_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "uuid"
    t.string "name"
    t.text "chords", default: "--- []\n"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_players_on_name"
    t.index ["uuid"], name: "index_players_on_uuid", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "duration", default: 1
    t.boolean "complete", default: false
    t.integer "player_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["player_id"], name: "index_sessions_on_player_id"
  end

  add_foreign_key "pairs", "sessions"
  add_foreign_key "sessions", "players"
end
