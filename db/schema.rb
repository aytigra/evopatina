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

ActiveRecord::Schema.define(version: 20151115143130) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer  "subsector_id", null: false
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "position"
  end

  add_index "activities", ["subsector_id"], name: "index_activities_on_subsector_id", using: :btree

  create_table "fragments", force: :cascade do |t|
    t.integer  "week_id",                   null: false
    t.integer  "activity_id",               null: false
    t.float    "count",       default: 0.0
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "fragments", ["activity_id"], name: "index_fragments_on_activity_id", using: :btree
  add_index "fragments", ["week_id"], name: "index_fragments_on_week_id", using: :btree

  create_table "sector_weeks", force: :cascade do |t|
    t.integer  "sector_id",                null: false
    t.integer  "week_id",                  null: false
    t.float    "lapa",       default: 0.0
    t.float    "progress",   default: 0.0
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "sector_weeks", ["sector_id"], name: "index_sector_weeks_on_sector_id", using: :btree
  add_index "sector_weeks", ["week_id"], name: "index_sector_weeks_on_week_id", using: :btree

  create_table "sectors", force: :cascade do |t|
    t.integer  "user_id",     null: false
    t.string   "name"
    t.text     "description"
    t.string   "icon"
    t.integer  "position"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "color"
  end

  add_index "sectors", ["user_id"], name: "index_sectors_on_user_id", using: :btree

  create_table "subsectors", force: :cascade do |t|
    t.integer  "sector_id",   null: false
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "position"
  end

  add_index "subsectors", ["sector_id"], name: "index_subsectors_on_sector_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "locale"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "weeks", force: :cascade do |t|
    t.date     "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "weeks", ["date"], name: "index_weeks_on_date", using: :btree

  add_foreign_key "activities", "subsectors"
  add_foreign_key "sectors", "users"
  add_foreign_key "subsectors", "sectors"
end
