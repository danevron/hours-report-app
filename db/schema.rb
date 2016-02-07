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

ActiveRecord::Schema.define(version: 20160207102831) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "days", force: true do |t|
    t.integer  "timesheet_id"
    t.date     "date"
    t.string   "day_type"
    t.float    "value"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "departments", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "expense_reports", force: true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "country"
    t.string   "currency"
    t.string   "status"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "timesheet_id"
    t.datetime "submitted_at"
  end

  add_index "expense_reports", ["user_id"], name: "index_expense_reports_on_user_id", using: :btree

  create_table "expenses", force: true do |t|
    t.string   "description"
    t.decimal  "amount"
    t.decimal  "quantity"
    t.string   "currency"
    t.integer  "expense_report_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "exchange_rate"
    t.datetime "purchased_at"
  end

  add_index "expenses", ["expense_report_id"], name: "index_expenses_on_expense_report_id", using: :btree

  create_table "invitations", force: true do |t|
    t.string  "recipient"
    t.string  "sender"
    t.integer "employee_number"
    t.string  "tenbis_number",   default: ""
    t.integer "department_id"
  end

  create_table "reminders", force: true do |t|
    t.integer  "report_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reports", force: true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.string   "status",      default: "open", null: false
    t.boolean  "current"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "tenbis_date"
  end

  create_table "roles", force: true do |t|
    t.string   "name",        null: false
    t.string   "title",       null: false
    t.text     "description", null: false
    t.json     "the_role",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tenbis", force: true do |t|
    t.datetime "date"
    t.text     "usage"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "timesheets", force: true do |t|
    t.integer  "user_id"
    t.integer  "report_id"
    t.string   "status"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "tenbis_usage"
  end

  create_table "users", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "refresh_token"
    t.string   "access_token"
    t.datetime "expires"
    t.string   "email"
    t.string   "image"
    t.string   "status",          default: "active", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role_id"
    t.integer  "employee_number"
    t.string   "tenbis_number",   default: ""
    t.integer  "department_id"
  end

end
