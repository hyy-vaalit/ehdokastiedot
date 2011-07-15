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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110715111242) do

  create_table "active_admin_comments", :force => true do |t|
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "candidates", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "candidate_name"
    t.string   "social_security_number"
    t.integer  "faculty_id"
    t.string   "address"
    t.string   "postal_information"
    t.string   "email"
    t.integer  "electoral_alliance_id"
    t.integer  "candidate_number"
    t.text     "notes"
    t.integer  "sign_up_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "electoral_alliances", :force => true do |t|
    t.string   "name"
    t.integer  "delivered_candidate_form_amount"
    t.boolean  "secretarial_freeze"
    t.integer  "electoral_coalition_id"
    t.integer  "signing_order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "primary_advocate_lastname"
    t.string   "primary_advocate_firstname"
    t.string   "primary_advocate_social_security_number"
    t.string   "primary_advocate_address"
    t.string   "primary_advocate_postal_information"
    t.string   "primary_advocate_phone"
    t.string   "primary_advocate_email"
    t.string   "secondary_advocate_lastname"
    t.string   "secondary_advocate_firstname"
    t.string   "secondary_advocate_social_security_number"
    t.string   "secondary_advocate_address"
    t.string   "secondary_advocate_postal_information"
    t.string   "secondary_advocate_phone"
    t.string   "secondary_advocate_email"
  end

  create_table "electoral_coalitions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "faculties", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
