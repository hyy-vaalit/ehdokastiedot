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

ActiveRecord::Schema[8.1].define(version: 2026_07_07_120003) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_admin_comments", id: :serial, force: :cascade do |t|
    t.integer "author_id"
    t.string "author_type"
    t.text "body"
    t.datetime "created_at", precision: nil
    t.string "namespace"
    t.integer "resource_id", null: false
    t.string "resource_type", null: false
    t.datetime "updated_at", precision: nil
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_admin_notes_on_resource_type_and_resource_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
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
    t.datetime "created_at", precision: nil, null: false
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

  create_table "admin_users", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "current_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", limit: 128, default: "", null: false
    t.datetime "last_sign_in_at", precision: nil
    t.string "last_sign_in_ip"
    t.datetime "remember_created_at", precision: nil
    t.datetime "reset_password_sent_at", precision: nil
    t.string "reset_password_token"
    t.string "role", null: false
    t.integer "sign_in_count", default: 0
    t.datetime "updated_at", precision: nil
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "advocate_teams", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.integer "primary_advocate_user_id", null: false
    t.datetime "updated_at", null: false
    t.index ["primary_advocate_user_id"], name: "index_advocate_teams_on_primary_advocate_user_id", unique: true
  end

  create_table "advocate_users", id: :serial, force: :cascade do |t|
    t.integer "advocate_team_id"
    t.datetime "created_at", precision: nil
    t.datetime "current_sign_in_at", precision: nil
    t.string "email", default: "", null: false
    t.string "firstname"
    t.datetime "last_sign_in_at", precision: nil
    t.string "lastname"
    t.string "phone_number"
    t.string "student_number", default: "", null: false
    t.datetime "updated_at", precision: nil
    t.index ["email"], name: "index_advocate_users_on_email", unique: true
    t.index ["student_number"], name: "index_advocate_users_on_student_number", unique: true
  end

  create_table "candidate_attribute_changes", id: :serial, force: :cascade do |t|
    t.string "attribute_name"
    t.integer "candidate_id"
    t.datetime "created_at", precision: nil
    t.string "new_value"
    t.string "previous_value"
    t.datetime "updated_at", precision: nil
  end

  create_table "candidates", id: :serial, force: :cascade do |t|
    t.string "address"
    t.boolean "alliance_accepted", default: false, null: false
    t.boolean "cancelled", default: false, null: false
    t.datetime "cancelled_at", precision: nil
    t.string "candidate_name", null: false
    t.integer "candidate_number"
    t.datetime "created_at", precision: nil
    t.integer "electoral_alliance_id", null: false
    t.string "email", null: false
    t.integer "faculty_id"
    t.string "firstname", null: false
    t.string "lastname", null: false
    t.text "notes"
    t.integer "numbering_order"
    t.string "phone_number"
    t.string "postal_city"
    t.string "postal_code"
    t.string "student_number", null: false
    t.datetime "updated_at", precision: nil
    t.index ["candidate_number"], name: "index_candidates_on_candidate_number", unique: true
    t.index ["student_number"], name: "allow_single_non_cancelled_candidate_per_student_number", unique: true, where: "(cancelled IS NOT TRUE)"
  end

  create_table "delayed_jobs", id: :serial, force: :cascade do |t|
    t.integer "attempts", default: 0
    t.datetime "created_at", precision: nil
    t.datetime "failed_at", precision: nil
    t.text "handler"
    t.text "last_error"
    t.datetime "locked_at", precision: nil
    t.string "locked_by"
    t.integer "priority", default: 0
    t.string "queue"
    t.datetime "run_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "electoral_alliances", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.integer "electoral_coalition_id"
    t.integer "expected_candidate_count"
    t.string "invite_code", null: false
    t.string "name"
    t.integer "numbering_order"
    t.integer "primary_advocate_id"
    t.boolean "secretarial_freeze", default: false
    t.string "shorten"
    t.datetime "updated_at", precision: nil
    t.index ["invite_code"], name: "index_electoral_alliances_on_invite_code", unique: true
  end

  create_table "electoral_coalitions", id: :serial, force: :cascade do |t|
    t.integer "advocate_team_id"
    t.datetime "created_at", precision: nil
    t.string "name"
    t.integer "numbering_order"
    t.string "shorten"
    t.datetime "updated_at", precision: nil
  end

  create_table "emails", id: :serial, force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", precision: nil
    t.datetime "enqueued_at", precision: nil
    t.string "subject"
    t.datetime "updated_at", precision: nil
  end

  create_table "faculties", id: :serial, force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", precision: nil
    t.string "name"
    t.integer "numeric_code", null: false
    t.datetime "updated_at", precision: nil
  end

  create_table "global_configurations", id: :serial, force: :cascade do |t|
    t.boolean "advocate_login_enabled", default: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "advocate_teams", "advocate_users", column: "primary_advocate_user_id"
  add_foreign_key "advocate_users", "advocate_teams"
  add_foreign_key "candidate_attribute_changes", "candidates", name: "candidate_attribute_changes_candidate_id_fk"
  add_foreign_key "candidates", "electoral_alliances", name: "candidates_electoral_alliance_id_fk"
  add_foreign_key "electoral_alliances", "advocate_users", column: "primary_advocate_id", name: "electoral_alliances_primary_advocate_id_fk"
  add_foreign_key "electoral_alliances", "electoral_coalitions", name: "electoral_alliances_electoral_coalition_id_fk"
  add_foreign_key "electoral_coalitions", "advocate_teams"
end
