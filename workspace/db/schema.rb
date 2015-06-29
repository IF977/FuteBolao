# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140506024517) do

  create_table "groups", force: true do |t|
    t.string   "name"
    t.boolean  "active",     default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["active"], name: "index_groups_on_active"

  create_table "guesses", force: true do |t|
    t.integer  "user_id"
    t.integer  "match_id"
    t.integer  "goals_a"
    t.integer  "goals_b"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "guesses", ["id", "user_id"], name: "index_guesses_on_id_and_user_id"
  add_index "guesses", ["match_id"], name: "index_guesses_on_match_id"
  add_index "guesses", ["user_id"], name: "index_guesses_on_user_id"

  create_table "matches", force: true do |t|
    t.datetime "datetime"
    t.integer  "team_a_id"
    t.integer  "team_b_id"
    t.integer  "goals_a"
    t.integer  "goals_b"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "matches", ["group_id"], name: "index_matches_on_group_id"
  add_index "matches", ["team_a_id"], name: "index_matches_on_team_a_id"
  add_index "matches", ["team_b_id"], name: "index_matches_on_team_b_id"

  create_table "teams", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teams", ["slug"], name: "index_teams_on_slug"

  create_table "users", force: true do |t|
    t.string   "email",               default: "", null: false
    t.boolean  "admin"
    t.integer  "position"
    t.integer  "score",               default: 0
    t.string   "encrypted_password",  default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "image"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
