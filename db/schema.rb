# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_02_04_093604) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", id: :serial, force: :cascade do |t|
    t.integer "resource_id", null: false
    t.string "resource_type", null: false
    t.integer "author_id"
    t.string "author_type"
    t.text "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "namespace"
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_admin_notes_on_resource_type_and_resource_id"
  end

  create_table "admin_users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", limit: 128, default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "role"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "advocate_users", id: :serial, force: :cascade do |t|
    t.string "ssn"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "email", default: "", null: false
    t.string "encrypted_password", limit: 128, default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "firstname"
    t.string "lastname"
    t.string "postal_address"
    t.string "postal_code"
    t.string "postal_city"
    t.string "phone_number"
    t.index ["email"], name: "index_advocate_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_advocate_users_on_reset_password_token", unique: true
  end

  create_table "candidate_attribute_changes", id: :serial, force: :cascade do |t|
    t.string "attribute_name"
    t.string "previous_value"
    t.string "new_value"
    t.integer "candidate_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "candidates", id: :serial, force: :cascade do |t|
    t.string "firstname"
    t.string "lastname"
    t.string "candidate_name"
    t.string "social_security_number"
    t.integer "faculty_id"
    t.string "address"
    t.string "postal_information"
    t.string "email"
    t.integer "electoral_alliance_id"
    t.integer "candidate_number"
    t.text "notes"
    t.integer "numbering_order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "cancelled", default: false
    t.boolean "marked_invalid", default: false
    t.string "phone_number"
  end

  create_table "delayed_jobs", id: :serial, force: :cascade do |t|
    t.integer "priority", default: 0
    t.integer "attempts", default: 0
    t.text "handler"
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "queue"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "electoral_alliances", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "expected_candidate_count"
    t.boolean "secretarial_freeze", default: false
    t.integer "electoral_coalition_id"
    t.integer "numbering_order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "shorten"
    t.integer "primary_advocate_id"
    t.integer "secondary_advocate_id"
  end

  create_table "electoral_coalitions", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "numbering_order"
    t.string "shorten"
  end

  create_table "emails", id: :serial, force: :cascade do |t|
    t.string "subject"
    t.text "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "enqueued_at"
  end

  create_table "faculties", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "numeric_code", null: false
  end

  create_table "global_configurations", id: :serial, force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "advocate_login_enabled", default: false
  end

  add_foreign_key "candidate_attribute_changes", "candidates", name: "candidate_attribute_changes_candidate_id_fk"
  add_foreign_key "candidates", "electoral_alliances", name: "candidates_electoral_alliance_id_fk"
  add_foreign_key "electoral_alliances", "advocate_users", column: "primary_advocate_id", name: "electoral_alliances_primary_advocate_id_fk"
  add_foreign_key "electoral_alliances", "advocate_users", column: "secondary_advocate_id", name: "electoral_alliances_secondary_advocate_id_fk"
  add_foreign_key "electoral_alliances", "electoral_coalitions", name: "electoral_alliances_electoral_coalition_id_fk"
end
