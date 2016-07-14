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

ActiveRecord::Schema.define(version: 20160714014028) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delayed_jobs", force: :cascade do |t|
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

  create_table "import_logs", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "site_count"
    t.integer  "trial_count"
  end

  create_table "sites", force: :cascade do |t|
    t.integer  "trial_id",          null: false
    t.text     "facility"
    t.text     "city"
    t.text     "state"
    t.text     "country"
    t.text     "zip_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.string   "contact_name"
    t.string   "contact_phone"
    t.string   "contact_phone_ext"
    t.string   "contact_email"
    t.float    "latitude"
    t.float    "longitude"
  end

  add_index "sites", ["trial_id"], name: "index_sites_on_trial_id", using: :btree

  create_table "trials", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "sponsor"
    t.string   "nct_id"
    t.string   "official_title"
    t.string   "agency_class"
    t.text     "detailed_description"
    t.string   "overall_status"
    t.string   "phase"
    t.string   "study_type"
    t.string   "gender"
    t.integer  "minimum_age",           default: 0,   null: false
    t.integer  "maximum_age",           default: 120, null: false
    t.string   "healthy_volunteers"
    t.string   "overall_contact_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "minimum_age_original"
    t.string   "maximum_age_original"
    t.string   "conditions",            default: [],               array: true
    t.text     "criteria"
    t.string   "countries",             default: [],               array: true
    t.string   "overall_contact_phone"
    t.string   "overall_contact_email"
    t.string   "link_url"
    t.string   "link_description"
    t.string   "first_received_date"
    t.string   "last_changed_date"
    t.string   "verification_date"
    t.string   "keywords",              default: [],               array: true
    t.string   "is_fda_regulated"
    t.string   "has_expanded_access"
  end

  add_index "trials", ["nct_id"], name: "index_trials_on_nct_id", unique: true, using: :btree

  create_table "zip_codes", force: :cascade do |t|
    t.string "zip_code"
    t.float  "latitude"
    t.float  "longitude"
  end

  add_foreign_key "sites", "trials"
end
