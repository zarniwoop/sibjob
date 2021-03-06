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

ActiveRecord::Schema.define(:version => 20110617003121) do

  create_table "job_records", :force => true do |t|
    t.integer  "job_id"
    t.integer  "performer_id"
    t.integer  "inspector_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "performed_on"
  end

  add_index "job_records", ["inspector_id"], :name => "index_job_records_on_inspector_id"
  add_index "job_records", ["performer_id"], :name => "index_job_records_on_performer_id"

  create_table "jobs", :force => true do |t|
    t.string   "summary"
    t.text     "description"
    t.integer  "pointvalue"
    t.integer  "sibling_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "interval"
    t.boolean  "assigned_to_everyone", :default => false
    t.boolean  "inspectable",          :default => true
    t.boolean  "active",               :default => true
  end

  add_index "jobs", ["sibling_id"], :name => "index_jobs_on_sibling_id"

  create_table "parents", :force => true do |t|
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

  add_index "parents", ["email"], :name => "index_parents_on_email", :unique => true
  add_index "parents", ["reset_password_token"], :name => "index_parents_on_reset_password_token", :unique => true

  create_table "siblings", :force => true do |t|
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

  add_index "siblings", ["email"], :name => "index_siblings_on_email", :unique => true
  add_index "siblings", ["reset_password_token"], :name => "index_siblings_on_reset_password_token", :unique => true

end
