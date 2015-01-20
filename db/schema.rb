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

ActiveRecord::Schema.define(version: 20150115223403) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "polling_statuses", force: true do |t|
    t.boolean  "currently_polling"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", force: true do |t|
    t.string   "sfdc_app_id"
    t.string   "sfdc_app_secret"
    t.string   "insights_app_id"
    t.string   "insights_api_key"
    t.string   "insights_event_name"
    t.string   "polling_interval"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sfdc_log_file_trackers", force: true do |t|
    t.string   "log_file_id"
    t.datetime "log_date"
    t.string   "log_file_type"
    t.boolean  "file_complete"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sfdc_logs", force: true do |t|
    t.string   "event_type"
    t.string   "log_date"
    t.string   "file_id"
    t.boolean  "sent_to_insights", default: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "oauth_token"
    t.string   "refresh_token"
    t.string   "instance_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end