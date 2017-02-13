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

ActiveRecord::Schema.define(version: 20170212173019) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alliance_users", force: :cascade do |t|
    t.integer  "alliance_id", null: false
    t.integer  "user_id",     null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "alliances", force: :cascade do |t|
    t.string   "name"
    t.string   "purpose"
    t.string   "webmeet_url"
    t.string   "state",       default: "initialized"
    t.string   "pid",                                 null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.string   "offering"
    t.string   "serving"
    t.string   "url"
    t.string   "location"
    t.string   "latitude"
    t.string   "longitude"
    t.string   "time_zone",  default: "Pacific Time (US & Canada)"
    t.date     "founded"
    t.string   "state",      default: "initialized"
    t.string   "pid",                                               null: false
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
  end

  create_table "company_users", force: :cascade do |t|
    t.integer  "company_id",             null: false
    t.integer  "user_id",                null: false
    t.integer  "share",      default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "okrs", force: :cascade do |t|
    t.string   "objective"
    t.string   "key_result_1"
    t.string   "key_result_2"
    t.string   "key_result_3"
    t.integer  "okr_duration"
    t.integer  "okr_units"
    t.date     "okr_start"
    t.integer  "mid_score"
    t.integer  "final_score"
    t.text     "postmortem"
    t.integer  "company_id",                           null: false
    t.string   "state",        default: "initialized"
    t.string   "pid",                                  null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name",             default: ""
    t.string   "last_name",              default: ""
    t.string   "username",               default: ""
    t.string   "tagline",                default: ""
    t.string   "twitter_profile",        default: ""
    t.string   "linkedin_profile",       default: ""
    t.string   "website",                default: ""
    t.string   "state",                  default: "unconfirmed"
    t.string   "role",                   default: "guest"
    t.string   "pid",                                                           null: false
    t.string   "acqsrc"
    t.string   "location"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "time_zone",              default: "Pacific Time (US & Canada)"
    t.string   "email",                  default: "",                           null: false
    t.string   "encrypted_password",     default: "",                           null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,                            null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
