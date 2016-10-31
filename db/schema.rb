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

ActiveRecord::Schema.define(version: 20161031041814) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "commentable_id",   null: false
    t.string   "commentable_type", null: false
    t.integer  "commenter_id",     null: false
    t.text     "body"
    t.text     "subject"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "type"
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["commenter_id"], name: "index_comments_on_commenter_id", using: :btree

  create_table "email_addresses", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.string   "address",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "email_addresses", ["address"], name: "index_email_addresses_on_address", unique: true, using: :btree
  add_index "email_addresses", ["user_id"], name: "index_email_addresses_on_user_id", using: :btree

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

  create_table "loan_requests", force: :cascade do |t|
    t.integer  "creator_id",                                    null: false
    t.uuid     "uuid",                                          null: false
    t.money    "amount_requested",      scale: 2,               null: false
    t.money    "amount_borrowed",       scale: 2, default: 0.0, null: false
    t.money    "amount_repaid",         scale: 2, default: 0.0, null: false
    t.datetime "disbursement_deadline"
    t.datetime "repayment_deadline"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  add_index "loan_requests", ["creator_id"], name: "index_loan_requests_on_creator_id", using: :btree
  add_index "loan_requests", ["uuid"], name: "index_loan_requests_on_uuid", unique: true, using: :btree

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

  create_table "temporary_signins", force: :cascade do |t|
    t.integer  "email_address_id",   null: false
    t.integer  "user_id",            null: false
    t.string   "confirmation_token", null: false
    t.string   "type"
    t.datetime "expires_at",         null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "temporary_signins", ["confirmation_token"], name: "index_temporary_signins_on_confirmation_token", unique: true, using: :btree

  create_table "transfer_participants", force: :cascade do |t|
    t.integer  "user_id",     null: false
    t.integer  "transfer_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "type"
  end

  add_index "transfer_participants", ["transfer_id", "user_id"], name: "index_transfer_participants_on_transfer_id_and_user_id", unique: true, using: :btree
  add_index "transfer_participants", ["transfer_id"], name: "index_transfer_participants_on_transfer_id", using: :btree
  add_index "transfer_participants", ["user_id"], name: "index_transfer_participants_on_user_id", using: :btree

  create_table "transfers", force: :cascade do |t|
    t.integer  "creator_id"
    t.integer  "amount_cents",     default: 0,     null: false
    t.string   "amount_currency",  default: "USD", null: false
    t.string   "description"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "sender_id",                        null: false
    t.integer  "recipient_id",                     null: false
    t.string   "type",                             null: false
    t.datetime "transferred_at"
    t.uuid     "uuid",                             null: false
    t.integer  "loan_request_id"
    t.integer  "balance_cents",    default: 0,     null: false
    t.string   "balance_currency", default: "USD", null: false
    t.string   "contact_name"
  end

  add_index "transfers", ["creator_id"], name: "index_transfers_on_creator_id", using: :btree
  add_index "transfers", ["loan_request_id"], name: "index_transfers_on_loan_request_id", using: :btree
  add_index "transfers", ["uuid"], name: "index_transfers_on_uuid", unique: true, using: :btree

  create_table "transitions", force: :cascade do |t|
    t.integer  "transitional_id",                null: false
    t.string   "transitional_type",              null: false
    t.string   "to_state",                       null: false
    t.json     "metadata",          default: {}
    t.integer  "sort_key",                       null: false
    t.boolean  "most_recent",                    null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "user_contacts", force: :cascade do |t|
    t.integer  "owner_id",              null: false
    t.integer  "contact_id",            null: false
    t.integer  "source_id"
    t.string   "source_type"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "fallback_display_name"
    t.string   "display_name"
  end

  add_index "user_contacts", ["contact_id", "owner_id"], name: "index_user_contacts_on_contact_id_and_owner_id", unique: true, using: :btree
  add_index "user_contacts", ["source_id", "source_type"], name: "index_user_contacts_on_source_id_and_source_type", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "encrypted_password"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.uuid     "uuid",                            null: false
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "users", ["uuid"], name: "index_users_on_uuid", unique: true, using: :btree

end
