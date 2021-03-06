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

ActiveRecord::Schema.define(version: 20150904015338) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "assistants", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "assistants", ["event_id"], name: "index_assistants_on_event_id", using: :btree
  add_index "assistants", ["user_id", "event_id"], name: "index_assistants_on_user_id_and_event_id", unique: true, using: :btree
  add_index "assistants", ["user_id"], name: "index_assistants_on_user_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "details",                    null: false
    t.string   "where",                      null: false
    t.date     "date",                       null: false
    t.time     "time"
    t.string   "image"
    t.integer  "creator_id",                 null: false
    t.boolean  "archived",   default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feeds", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.integer  "feed_creator_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "feeds", ["event_id"], name: "index_feeds_on_event_id", using: :btree
  add_index "feeds", ["user_id"], name: "index_feeds_on_user_id", using: :btree

  create_table "follows", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followed_id"
    t.string  "status"
  end

  add_index "follows", ["followed_id"], name: "index_follows_on_followed_id", using: :btree
  add_index "follows", ["follower_id", "followed_id"], name: "index_follows_on_follower_id_and_followed_id", unique: true, using: :btree
  add_index "follows", ["follower_id"], name: "index_follows_on_follower_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                           null: false
    t.string   "password_digest",                 null: false
    t.string   "name",                            null: false
    t.date     "birthdate",                       null: false
    t.string   "gender",                          null: false
    t.boolean  "is_private",      default: false, null: false
    t.string   "bio",             default: "",    null: false
    t.boolean  "archived",        default: false, null: false
    t.string   "auth_token"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
