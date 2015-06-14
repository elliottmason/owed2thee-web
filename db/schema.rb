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

ActiveRecord::Schema.define(version: 20150614014415) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "groupings", force: :cascade do |t|
    t.integer  "group_id",       null: false
    t.integer  "groupable_id",   null: false
    t.string   "groupable_type", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "groupings", ["group_id"], name: "index_groupings_on_group_id", using: :btree
  add_index "groupings", ["groupable_type", "groupable_id"], name: "index_groupings_on_groupable_type_and_groupable_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.integer  "projected_amount_cents",    default: 0,     null: false
    t.string   "projected_amount_currency", default: "USD", null: false
    t.integer  "confirmed_amount_cents",    default: 0,     null: false
    t.string   "confirmed_amount_currency", default: "USD", null: false
    t.string   "description"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "type"
  end

  create_table "ledgers", force: :cascade do |t|
    t.integer  "user_a_id",                                  null: false
    t.integer  "user_b_id",                                  null: false
    t.integer  "confirmed_balance_cents",    default: 0,     null: false
    t.string   "confirmed_balance_currency", default: "USD", null: false
    t.integer  "projected_balance_cents",    default: 0,     null: false
    t.string   "projected_balance_currency", default: "USD", null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "ledgers", ["user_a_id", "user_b_id"], name: "index_ledgers_on_user_a_id_and_user_b_id", unique: true, using: :btree

  create_table "loan_payments", force: :cascade do |t|
    t.integer  "loan_id",                         null: false
    t.integer  "payment_id",                      null: false
    t.integer  "amount_cents",    default: 0,     null: false
    t.string   "amount_currency", default: "USD", null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "creator_id"
    t.integer  "payable_id",                      null: false
    t.string   "payable_type",                    null: false
    t.integer  "payer_id",                        null: false
    t.integer  "amount_cents",    default: 0,     null: false
    t.string   "amount_currency", default: "USD", null: false
    t.datetime "paid_at"
    t.string   "type"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "payments", ["payable_id", "payable_type"], name: "index_payments_on_payable_id_and_payable_type", using: :btree
  add_index "payments", ["payer_id"], name: "index_payments_on_payer_id", using: :btree

  create_table "transfer_participants", force: :cascade do |t|
    t.integer  "user_id",           null: false
    t.integer  "participable_id",   null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "type"
    t.string   "participable_type"
  end

  add_index "transfer_participants", ["participable_id", "participable_type", "user_id"], name: "index_transfer_participants_participable_user_id", unique: true, using: :btree
  add_index "transfer_participants", ["participable_id", "participable_type"], name: "index_transfer_participants_on_participable", using: :btree
  add_index "transfer_participants", ["user_id"], name: "index_transfer_participants_on_user_id", using: :btree

  create_table "transfers", force: :cascade do |t|
    t.integer  "creator_id"
    t.integer  "amount_cents",    default: 0,     null: false
    t.string   "amount_currency", default: "USD", null: false
    t.string   "description"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "sender_id",                       null: false
    t.string   "sender_type",                     null: false
    t.integer  "recipient_id",                    null: false
    t.string   "recipient_type",                  null: false
    t.string   "type",                            null: false
  end

  add_index "transfers", ["creator_id"], name: "index_transfers_on_creator_id", using: :btree
  add_index "transfers", ["recipient_type", "recipient_id"], name: "index_transfers_on_recipient_type_and_recipient_id", using: :btree
  add_index "transfers", ["sender_type", "sender_id"], name: "index_transfers_on_sender_type_and_sender_id", using: :btree

  create_table "transitions", force: :cascade do |t|
    t.integer  "transitional_id",                null: false
    t.string   "transitional_type",              null: false
    t.string   "to_state",                       null: false
    t.json     "metadata",          default: {}
    t.integer  "sort_key",                       null: false
    t.boolean  "most_recent",                    null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "type"
  end

  add_index "transitions", ["transitional_id", "transitional_type", "type", "most_recent"], name: "index_transitions_parent_sort", unique: true, using: :btree
  add_index "transitions", ["transitional_id", "transitional_type", "type", "sort_key"], name: "index_transitions_parent_most_recent", unique: true, using: :btree

  create_table "user_emails", force: :cascade do |t|
    t.integer  "user_id",              null: false
    t.string   "email",                null: false
    t.string   "confirmation_token"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "user_emails", ["confirmation_token"], name: "index_user_emails_on_confirmation_token", unique: true, using: :btree
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
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
