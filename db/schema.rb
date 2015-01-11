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

ActiveRecord::Schema.define(version: 20141214102644) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "hashtags", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hashtags", ["name"], name: "index_hashtags_on_name", unique: true, using: :btree

  create_table "hashtags_statuses", id: false, force: true do |t|
    t.integer "status_id",  null: false
    t.integer "hashtag_id", null: false
  end

  add_index "hashtags_statuses", ["hashtag_id", "status_id"], name: "index_hashtags_statuses_on_hashtag_id_and_status_id", unique: true, using: :btree
  add_index "hashtags_statuses", ["status_id", "hashtag_id"], name: "index_hashtags_statuses_on_status_id_and_hashtag_id", unique: true, using: :btree

  create_table "statuses", force: true do |t|
    t.text     "description", null: false
    t.integer  "user_id",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "statuses", ["user_id"], name: "index_statuses_on_user_id", using: :btree

  create_table "teams", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "first_name", null: false
    t.string   "last_name",  null: false
    t.string   "email",      null: false
    t.string   "title"
    t.integer  "team_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["team_id", "email"], name: "index_users_on_team_id_and_email", unique: true, using: :btree
  add_index "users", ["team_id"], name: "index_users_on_team_id", using: :btree

end
