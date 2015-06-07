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

ActiveRecord::Schema.define(version: 20150607041101) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "loan_borrowers", force: :cascade do |t|
    t.integer  "borrower_id",  null: false
    t.integer  "loan_id",      null: false
    t.datetime "confirmed_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "loan_borrowers", ["borrower_id", "loan_id"], name: "index_loan_borrowers_on_borrower_id_and_loan_id", unique: true, using: :btree
  add_index "loan_borrowers", ["borrower_id"], name: "index_loan_borrowers_on_borrower_id", using: :btree
  add_index "loan_borrowers", ["loan_id"], name: "index_loan_borrowers_on_loan_id", using: :btree

  create_table "loan_groups", force: :cascade do |t|
    t.integer  "projected_amount_cents",    default: 0,     null: false
    t.string   "projected_amount_currency", default: "USD", null: false
    t.integer  "confirmed_amount_cents",    default: 0,     null: false
    t.string   "confirmed_amount_currency", default: "USD", null: false
    t.string   "description"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  create_table "loans", force: :cascade do |t|
    t.integer  "creator_id"
    t.integer  "group_id"
    t.integer  "lender_id",                       null: false
    t.integer  "amount_cents",    default: 0,     null: false
    t.string   "amount_currency", default: "USD", null: false
    t.string   "description"
    t.datetime "confirmed_at"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "loans", ["creator_id"], name: "index_loans_on_creator_id", using: :btree
  add_index "loans", ["group_id"], name: "index_loans_on_group_id", using: :btree
  add_index "loans", ["lender_id"], name: "index_loans_on_lender_id", using: :btree

  create_table "user_emails", force: :cascade do |t|
    t.integer  "user_id",              null: false
    t.string   "email",                null: false
    t.string   "confirmation_token"
    t.datetime "confirmation_sent_at"
    t.datetime "confirmed_at"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "user_emails", ["email"], name: "index_user_emails_on_email", unique: true, using: :btree
  add_index "user_emails", ["user_id"], name: "index_user_emails_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "encrypted_password"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "confirmed_at"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
