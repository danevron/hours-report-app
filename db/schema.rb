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

ActiveRecord::Schema.define(version: 20131122165028) do

  create_table "reports", force: true do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "status"
    t.boolean  "current"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_reports", force: true do |t|
    t.integer "report_id"
    t.integer "user_id"
  end

  add_index "user_reports", ["report_id", "user_id"], name: "index_user_reports_on_report_id_and_user_id"
  add_index "user_reports", ["user_id"], name: "index_user_reports_on_user_id"

  create_table "users", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "refresh_token"
    t.string   "access_token"
    t.datetime "expires"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "image"
    t.string   "status",        default: "active", null: false
  end

end
