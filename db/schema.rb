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

ActiveRecord::Schema.define(version: 20170728165146) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "fuzzystrmatch"
  enable_extension "pg_trgm"
  enable_extension "unaccent"

  create_table "alliance_users", force: :cascade do |t|
    t.integer  "alliance_id", null: false
    t.integer  "user_id",     null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "alliances", force: :cascade do |t|
    t.string   "name"
    t.string   "mission"
    t.string   "webmeet_url"
    t.string   "state",       default: "initialized"
    t.string   "pid",                                 null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "creator_id"
    t.boolean  "recruiting",  default: true
    t.boolean  "is_unlisted", default: false
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.text     "mission"
    t.string   "primary_market"
    t.string   "url"
    t.string   "location"
    t.string   "latitude"
    t.string   "longitude"
    t.string   "time_zone",      default: "Pacific Time (US & Canada)"
    t.date     "founded"
    t.string   "state",          default: "initialized"
    t.string   "pid",                                                   null: false
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.integer  "phases",         default: 0
    t.string   "webmeet_url"
    t.integer  "sakpi_index",    default: 0
    t.integer  "creator_id"
    t.boolean  "recruiting",     default: true
    t.boolean  "is_unlisted",    default: false
  end

  create_table "company_sakpis", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "sakpi_id"
    t.integer  "level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "company_users", force: :cascade do |t|
    t.integer  "company_id",             null: false
    t.integer  "user_id",                null: false
    t.integer  "equity",     default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "role",       default: 0
  end

  create_table "conversations", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.string   "pid",          null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "discussions", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "discussable_type", null: false
    t.integer  "discussable_id",   null: false
    t.string   "pid",              null: false
    t.integer  "author_id",        null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["discussable_type", "discussable_id"], name: "index_discussions_on_discussable_type_and_discussable_id", using: :btree
  end

  create_table "messages", force: :cascade do |t|
    t.text     "body"
    t.integer  "conversation_id"
    t.integer  "user_id"
    t.boolean  "is_read",         default: false
    t.string   "pid",                             null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id", using: :btree
    t.index ["user_id"], name: "index_messages_on_user_id", using: :btree
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

  create_table "posts", force: :cascade do |t|
    t.text     "body"
    t.integer  "discussion_id", null: false
    t.string   "pid",           null: false
    t.integer  "author_id",     null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "replies", force: :cascade do |t|
    t.text     "body"
    t.integer  "post_id",    null: false
    t.string   "pid",        null: false
    t.integer  "author_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sakpis", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "skills", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "traits", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_skills", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "skill_id"
    t.integer  "level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_traits", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "trait_id"
    t.integer  "level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name",             default: ""
    t.string   "last_name",              default: ""
    t.string   "username",               default: ""
    t.string   "mission",                default: ""
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
    t.integer  "skill_index",            default: 0
    t.integer  "trait_index",            default: 0
    t.boolean  "company_owner",          default: false
    t.string   "plan",                   default: "guest"
    t.index "lower((username)::text) text_pattern_ops", name: "users_username_lower", unique: true, using: :btree
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
