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

ActiveRecord::Schema.define(version: 20180921145818) do

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
    t.string   "webmeet_code"
    t.string   "pid",                          null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "creator_id"
    t.boolean  "recruiting",   default: true
    t.boolean  "is_unlisted",  default: false
    t.string   "invite_token"
    t.integer  "state",        default: 0
    t.boolean  "invite_only",  default: false
    t.integer  "leader_id"
    t.integer  "member_cap",   default: 12
  end

  create_table "audits", force: :cascade do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.jsonb    "audited_changes"
    t.integer  "version",         default: 0
    t.string   "comment"
    t.string   "remote_address"
    t.string   "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index", using: :btree
    t.index ["auditable_type", "auditable_id"], name: "auditable_index", using: :btree
    t.index ["created_at"], name: "index_audits_on_created_at", using: :btree
    t.index ["request_uuid"], name: "index_audits_on_request_uuid", using: :btree
    t.index ["user_id", "user_type"], name: "user_index", using: :btree
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "classifieds", force: :cascade do |t|
    t.string   "title"
    t.string   "body"
    t.string   "creator_id"
    t.string   "pid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name",                           null: false
    t.text     "mission"
    t.string   "primary_market"
    t.string   "url"
    t.string   "country_code"
    t.string   "time_zone"
    t.date     "founded"
    t.string   "pid",                            null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "phases",         default: 0
    t.string   "webmeet_code"
    t.integer  "sakpi_index",    default: 0
    t.integer  "creator_id"
    t.boolean  "recruiting",     default: true
    t.boolean  "is_unlisted",    default: false
    t.string   "invite_token"
    t.integer  "state",          default: 0
    t.integer  "member_cap",     default: 24
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
    t.string   "name"
    t.string   "discussable_type"
    t.integer  "discussable_id"
    t.string   "pid",                              null: false
    t.integer  "author_id",                        null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.boolean  "nucleus",          default: false
    t.datetime "deleted_at"
    t.string   "description"
    t.string   "slug"
    t.index ["deleted_at"], name: "index_discussions_on_deleted_at", using: :btree
    t.index ["discussable_type", "discussable_id"], name: "index_discussions_on_discussable_type_and_discussable_id", using: :btree
  end

  create_table "events", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.datetime "start_time"
    t.integer  "event_type"
    t.integer  "organizer_id"
    t.integer  "alliance_id"
    t.string   "access_url"
    t.string   "state",        default: "Proposed"
    t.string   "pid"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "fastrs", force: :cascade do |t|
    t.integer "fast_id"
    t.integer "strategy_id"
    t.index ["fast_id", "strategy_id"], name: "index_fastrs_on_fast_id_and_strategy_id", unique: true, using: :btree
  end

  create_table "fasts", force: :cascade do |t|
    t.string   "body"
    t.integer  "type_code",  default: 0
    t.integer  "company_id"
    t.integer  "user_id"
    t.string   "pid",                    null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "okr_id"
    t.integer  "sakpi_id"
    t.index ["company_id"], name: "index_fasts_on_company_id", using: :btree
    t.index ["user_id"], name: "index_fasts_on_user_id", using: :btree
  end

  create_table "messages", force: :cascade do |t|
    t.text     "body"
    t.integer  "conversation_id"
    t.integer  "user_id"
    t.string   "pid",                             null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "read",            default: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id", using: :btree
    t.index ["user_id"], name: "index_messages_on_user_id", using: :btree
  end

  create_table "offers", force: :cascade do |t|
    t.string   "header_1"
    t.string   "header_2"
    t.string   "offer_lead_in"
    t.text     "box_2"
    t.integer  "plan_id"
    t.string   "coupon"
    t.datetime "valid_through"
    t.string   "pid",             null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "benefit_lead_in"
    t.text     "box_1"
    t.string   "video_url"
    t.string   "cta_button_text"
    t.text     "box_3"
    t.index ["pid"], name: "index_offers_on_pid", using: :btree
  end

  create_table "okrs", force: :cascade do |t|
    t.string   "objective"
    t.string   "key_result_1"
    t.string   "key_result_2"
    t.string   "key_result_3"
    t.integer  "okr_duration"
    t.integer  "okr_units"
    t.date     "okr_start"
    t.integer  "status",       default: 0
    t.text     "postmortem"
    t.integer  "company_id",                 null: false
    t.string   "pid",                        null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.float    "score",        default: 0.0
    t.float    "kr1_score",    default: 0.0
    t.float    "kr2_score",    default: 0.0
    t.float    "kr3_score",    default: 0.0
    t.integer  "owner_id"
    t.integer  "sakpi_id"
    t.date     "okr_finish"
  end

  create_table "pages", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.string   "pid",                          null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.datetime "deleted_at"
    t.integer  "author_id"
    t.string   "state",      default: "Draft"
    t.index ["deleted_at"], name: "index_pages_on_deleted_at", using: :btree
    t.index ["title"], name: "index_pages_on_title", using: :btree
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text     "content"
    t.string   "searchable_type"
    t.integer  "searchable_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id", using: :btree
  end

  create_table "plans", force: :cascade do |t|
    t.string   "name"
    t.integer  "amount"
    t.string   "stripe_id"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "trial_period_days", default: 0
    t.string   "display_name"
    t.string   "display_price"
    t.string   "state",             default: "active"
  end

  create_table "posts", force: :cascade do |t|
    t.text     "body"
    t.integer  "topic_id",   null: false
    t.string   "pid",        null: false
    t.integer  "author_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "ancestry"
    t.datetime "deleted_at"
    t.index ["ancestry"], name: "index_posts_on_ancestry", using: :btree
    t.index ["created_at"], name: "index_posts_on_created_at", using: :btree
    t.index ["deleted_at"], name: "index_posts_on_deleted_at", using: :btree
  end

  create_table "prospects", force: :cascade do |t|
    t.string   "email"
    t.string   "acqsrc"
    t.integer  "offer_id"
    t.boolean  "subscribed", default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "quarks", force: :cascade do |t|
    t.string   "text"
    t.integer  "author_id"
    t.string   "state",      default: "Contributed"
    t.string   "pid",                                null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "read_marks", force: :cascade do |t|
    t.string   "readable_type", null: false
    t.integer  "readable_id"
    t.string   "reader_type",   null: false
    t.integer  "reader_id"
    t.datetime "timestamp"
    t.index ["readable_type", "readable_id"], name: "index_read_marks_on_readable_type_and_readable_id", using: :btree
    t.index ["reader_id", "reader_type", "readable_type", "readable_id"], name: "read_marks_reader_readable_index", unique: true, using: :btree
    t.index ["reader_type", "reader_id"], name: "index_read_marks_on_reader_type_and_reader_id", using: :btree
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

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.string   "taggable_type"
    t.integer  "taggable_id"
    t.string   "tagger_type"
    t.integer  "tagger_id"
    t.string   "context",       limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context", using: :btree
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
    t.index ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy", using: :btree
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id", using: :btree
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type", using: :btree
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type", using: :btree
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id", using: :btree
  end

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true, using: :btree
  end

  create_table "topics", force: :cascade do |t|
    t.string   "name"
    t.integer  "discussion_id", null: false
    t.string   "pid",           null: false
    t.integer  "author_id",     null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_topics_on_deleted_at", using: :btree
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
    t.string   "pid",                                            null: false
    t.string   "acqsrc"
    t.string   "country_code"
    t.string   "time_zone"
    t.string   "email",                  default: "",            null: false
    t.string   "encrypted_password",     default: "",            null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,             null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.integer  "skill_index",            default: 0
    t.integer  "trait_index",            default: 0
    t.boolean  "company_owner",          default: false
    t.boolean  "public_skills",          default: false
    t.boolean  "public_traits",          default: false
    t.string   "stripe_customer_id"
    t.integer  "plan_id"
    t.datetime "subscribed_at"
    t.string   "subscription_state"
    t.string   "stripe_coupon_code"
    t.integer  "audits_count",           default: 0,             null: false
    t.integer  "pages_count",            default: 0,             null: false
    t.integer  "posts_count",            default: 0,             null: false
    t.integer  "topics_count",           default: 0,             null: false
    t.string   "work_role",              default: "Unset"
    t.string   "card_brand"
    t.string   "last4"
    t.date     "card_expiry"
    t.integer  "quarks_count",           default: 0,             null: false
    t.integer  "events_count",           default: 0,             null: false
    t.index "lower((username)::text) text_pattern_ops", name: "users_username_lower", unique: true, using: :btree
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["stripe_customer_id"], name: "index_users_on_stripe_customer_id", using: :btree
  end

  create_table "votes", force: :cascade do |t|
    t.string   "votable_type"
    t.integer  "votable_id"
    t.string   "voter_type"
    t.integer  "voter_id"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree
  end

end
