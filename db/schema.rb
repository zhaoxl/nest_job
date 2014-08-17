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

ActiveRecord::Schema.define(version: 20140817085940) do

  create_table "account_post_applies", force: true do |t|
    t.integer  "account_id"
    t.integer  "post_id"
    t.float    "price"
    t.string   "message"
    t.string   "reply"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "account_radars", force: true do |t|
    t.integer  "account_id"
    t.string   "idea"
    t.boolean  "can_search",          default: true
    t.boolean  "subscribe",           default: true
    t.integer  "subscribe_frequency", default: 3
    t.datetime "start_date"
    t.datetime "end_date"
  end

  create_table "account_resume_educations", force: true do |t|
    t.integer "account_resume_id"
    t.string  "name"
    t.string  "school"
    t.string  "major"
    t.date    "start_date"
    t.date    "end_date"
    t.integer "account_id"
  end

  create_table "account_resume_experiences", force: true do |t|
    t.string   "company_name"
    t.string   "post"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "description",       limit: 2000
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_resume_id"
    t.integer  "salary"
    t.integer  "account_id"
  end

  create_table "account_resume_objects", force: true do |t|
    t.integer "account_resume_id"
    t.string  "name"
    t.string  "project_desc",      limit: 2000
    t.string  "role_desc",         limit: 2000
    t.date    "start_date"
    t.date    "end_date"
    t.integer "account_id"
  end

  create_table "account_resume_radars", force: true do |t|
    t.integer "account_resume_id"
    t.string  "status"
    t.boolean "be_searched",          default: false
    t.boolean "subscribe",            default: false
    t.integer "subscribe_frequency"
    t.date    "subscribe_start_date"
    t.date    "subscribe_end_date"
  end

  create_table "account_resume_tags", force: true do |t|
    t.integer "account_resume_id"
    t.integer "tag_id"
  end

  create_table "account_resumes", force: true do |t|
    t.integer  "account_id"
    t.float    "price"
    t.string   "title"
    t.string   "hope_area"
    t.string   "hope_salary"
    t.string   "education"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "tel"
    t.string   "email"
    t.datetime "birthday"
    t.integer  "gender"
    t.date     "work_start_date"
    t.string   "marital_status"
    t.string   "address"
  end

  create_table "account_tags", force: true do |t|
    t.integer "account_id"
    t.integer "tag_id"
  end

  create_table "accounts", force: true do |t|
    t.string   "email"
    t.string   "password"
    t.string   "nick_name"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.integer  "account_type",           default: 0
    t.string   "status",                 default: "prospective"
    t.integer  "company_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.string   "encrypted_password",     default: "",            null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,             null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "description"
    t.string   "company_email"
    t.integer  "industry_id"
  end

  add_index "accounts", ["email"], name: "index_accounts_on_email", unique: true, using: :btree
  add_index "accounts", ["reset_password_token"], name: "index_accounts_on_reset_password_token", unique: true, using: :btree

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "area_cities", force: true do |t|
    t.integer "area_province_id"
    t.string  "city_name"
  end

  create_table "area_countries", force: true do |t|
    t.integer "area_city_id"
    t.string  "country_name"
  end

  create_table "area_provinces", force: true do |t|
    t.string "province_name"
  end

  create_table "auditions", force: true do |t|
    t.integer  "workflow_id"
    t.string   "status"
    t.integer  "worker_account_id"
    t.integer  "hr_account_id"
    t.integer  "post_id"
    t.integer  "company_id"
    t.integer  "price"
    t.string   "message",           limit: 2000
    t.string   "reply",             limit: 2000
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authorizations", force: true do |t|
    t.integer "account_id"
    t.string  "provider"
    t.string  "uid"
    t.string  "token"
    t.string  "nickname"
    t.string  "logo"
    t.string  "gender"
    t.string  "province"
    t.string  "city"
  end

  create_table "bills", force: true do |t|
    t.integer  "account_id"
    t.integer  "from_account_id"
    t.string   "item_name"
    t.string   "item_type"
    t.integer  "item_id"
    t.string   "description"
    t.float    "before_alance"
    t.float    "after_alance"
    t.float    "money"
    t.string   "status"
    t.datetime "created_at"
    t.integer  "action_type"
  end

  create_table "companies", force: true do |t|
    t.string   "name"
    t.string   "home_page"
    t.integer  "financing_stage_id"
    t.string   "area"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.integer  "nature_id"
    t.integer  "industry_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tel"
    t.string   "email"
    t.text     "content"
  end

  create_table "company_invites", force: true do |t|
    t.integer  "company_id"
    t.integer  "account_id"
    t.string   "message",    limit: 300
    t.string   "reply"
    t.string   "status"
    t.integer  "price"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "company_members", force: true do |t|
    t.string   "name"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "post"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
  end

  create_table "company_scenes", force: true do |t|
    t.string   "name"
    t.integer  "company_id"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  create_table "favorites", force: true do |t|
    t.integer  "account_id"
    t.string   "item_type"
    t.integer  "item_id"
    t.datetime "created_at"
  end

  create_table "financing_stages", force: true do |t|
    t.string "name"
  end

  create_table "hot_search_tags", force: true do |t|
    t.string   "cookie_id"
    t.integer  "account_id"
    t.string   "name"
    t.integer  "search_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "industry_id"
  end

  create_table "hr_search_logs", force: true do |t|
    t.integer  "account_id"
    t.string   "area"
    t.string   "post"
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "search_num", default: 0
  end

  create_table "industries", force: true do |t|
    t.string "name"
  end

  create_table "messages", force: true do |t|
    t.integer  "sender_account_id"
    t.integer  "receiver_account_id"
    t.string   "item_type"
    t.integer  "item_id"
    t.string   "title",               limit: 200
    t.string   "description",         limit: 2000
    t.text     "content"
    t.datetime "expire_at"
    t.string   "status"
    t.integer  "message_level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "natures", force: true do |t|
    t.string "name"
  end

  create_table "post_tags", force: true do |t|
    t.integer "post_id"
    t.integer "tag_id"
  end

  create_table "posts", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.text     "content"
    t.string   "area"
    t.integer  "account_id"
    t.integer  "company_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "price_min",        default: 0
    t.integer  "price_max",        default: 0
    t.string   "address"
    t.string   "department"
    t.string   "email"
    t.integer  "look_num",         default: 0
    t.integer  "industry_id"
    t.text     "sanitize_content"
    t.string   "status"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree

  create_table "tags", force: true do |t|
    t.integer  "parent_id"
    t.string   "name"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "tries", force: true do |t|
    t.integer  "company_id"
    t.integer  "account_id"
    t.string   "reply"
    t.string   "status"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "worker_invites", force: true do |t|
    t.integer  "account_id"
    t.integer  "company_id"
    t.integer  "account_resume_id"
    t.string   "message",           limit: 300
    t.string   "reply"
    t.string   "status"
    t.integer  "price"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "workflows", force: true do |t|
    t.integer  "worker_account_id"
    t.integer  "hr_account_id"
    t.integer  "post_id"
    t.integer  "company_id"
    t.string   "status"
    t.string   "work_class_name"
    t.integer  "price"
    t.string   "message",           limit: 2000
    t.string   "reply",             limit: 2000
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
