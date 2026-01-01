# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_12_31_105919) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "employee_profiles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "department"
    t.string "designation"
    t.string "employee_id"
    t.integer "employment_type"
    t.date "exit_date"
    t.date "joining_date"
    t.integer "status"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_employee_profiles_on_user_id"
  end

  create_table "employment_events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "employee_profile_id", null: false
    t.date "event_date"
    t.integer "event_type"
    t.text "notes"
    t.datetime "updated_at", null: false
    t.index ["employee_profile_id"], name: "index_employment_events_on_employee_profile_id"
  end

  create_table "jwt_denylists", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "exp"
    t.string "jti"
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_jwt_denylists_on_jti"
  end

  create_table "leaves", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "employee_profile_id", null: false
    t.date "end_date"
    t.integer "leave_type"
    t.text "reason"
    t.date "start_date"
    t.integer "status"
    t.datetime "updated_at", null: false
    t.index ["employee_profile_id"], name: "index_leaves_on_employee_profile_id"
  end

  create_table "salaries", force: :cascade do |t|
    t.decimal "base_salary"
    t.decimal "bonus"
    t.datetime "created_at", null: false
    t.decimal "deductions"
    t.date "effective_from"
    t.bigint "employee_profile_id", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_profile_id"], name: "index_salaries_on_employee_profile_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.text "bio"
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "firstname", default: "", null: false
    t.string "github_username"
    t.string "lastname", default: "", null: false
    t.string "linkedin_url"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "role", default: "employee", null: false
    t.datetime "updated_at", null: false
    t.string "username", default: "", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "employee_profiles", "users"
  add_foreign_key "employment_events", "employee_profiles"
  add_foreign_key "leaves", "employee_profiles"
  add_foreign_key "salaries", "employee_profiles"
end
