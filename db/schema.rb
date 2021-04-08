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

ActiveRecord::Schema.define(version: 2021_04_08_041610) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "applications", force: :cascade do |t|
    t.string "round", null: false
    t.string "jobs_retained", null: false
    t.string "amount_approved", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ein"
    t.string "business_name"
    t.string "bin"
    t.string "naics"
    t.string "zip"
    t.string "county"
    t.string "city"
    t.string "business_type"
    t.string "business_size"
    t.bigint "company_id", null: false
    t.index ["company_id"], name: "index_applications_on_company_id"
  end

  create_table "companies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "business_name"
    t.string "ein"
    t.string "bin"
    t.string "naics"
    t.string "zip"
    t.string "county"
    t.string "city"
    t.string "business_type"
    t.string "business_size"
    t.string "street_address"
    t.string "amount_requested"
    t.string "number_of_employees"
    t.string "notes"
    t.string "phone"
    t.string "email"
  end

  create_table "companies_owners", id: false, force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "owner_id", null: false
    t.index ["company_id", "owner_id"], name: "index_companies_owners_on_company_id_and_owner_id"
    t.index ["owner_id", "company_id"], name: "index_companies_owners_on_owner_id_and_company_id"
  end

  create_table "owners", force: :cascade do |t|
    t.string "name", null: false
    t.string "percent_ownership", null: false
    t.string "race", null: false
    t.string "ethnicity", null: false
    t.string "gender", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ein"
  end

  create_table "queries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "uploads", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.bigint "user_id"
    t.string "ein"
    t.string "bin"
    t.string "data"
    t.string "round"
    t.index ["user_id"], name: "index_uploads_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.integer "role", default: 0, null: false
    t.boolean "active", default: true, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "applications", "companies"
end
