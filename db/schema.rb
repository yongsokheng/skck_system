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

ActiveRecord::Schema.define(version: 2016022206262240) do

  create_table "bank_types", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.string   "account_code",  limit: 255
    t.float    "balance_total", limit: 24
    t.integer  "cash_type_id",  limit: 4
    t.integer  "company_id",    limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "bank_types", ["cash_type_id"], name: "index_bank_types_on_cash_type_id", using: :btree
  add_index "bank_types", ["company_id"], name: "index_bank_types_on_company_id", using: :btree

  create_table "cash_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "chart_account_types", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.string   "type_code",     limit: 255
    t.integer  "increament_at", limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "chart_of_account_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id",   limit: 4, null: false
    t.integer "descendant_id", limit: 4, null: false
    t.integer "generations",   limit: 4, null: false
  end

  add_index "chart_of_account_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "chart_of_account_anc_desc_idx", unique: true, using: :btree
  add_index "chart_of_account_hierarchies", ["descendant_id"], name: "chart_of_account_desc_idx", using: :btree

  create_table "chart_of_accounts", force: :cascade do |t|
    t.string   "account_no",               limit: 255
    t.string   "name",                     limit: 255
    t.string   "description",              limit: 255
    t.float    "statement_ending_balance", limit: 24,  default: 0.0
    t.date     "statement_ending_date"
    t.integer  "parent_id",                limit: 4
    t.integer  "chart_account_type_id",    limit: 4
    t.integer  "company_id",               limit: 4
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  add_index "chart_of_accounts", ["chart_account_type_id"], name: "index_chart_of_accounts_on_chart_account_type_id", using: :btree
  add_index "chart_of_accounts", ["company_id"], name: "index_chart_of_accounts_on_company_id", using: :btree

  create_table "companies", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "short_name", limit: 255
    t.string   "address",    limit: 255
    t.string   "contact",    limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "customer_venders", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.string   "email",         limit: 255
    t.string   "address",       limit: 255
    t.string   "contact",       limit: 255
    t.string   "status",        limit: 255
    t.integer  "company_id",    limit: 4
    t.float    "balance_total", limit: 24
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "customer_venders", ["company_id"], name: "index_customer_venders_on_company_id", using: :btree

  create_table "journal_entries", force: :cascade do |t|
    t.date     "transaction_date"
    t.integer  "user_id",          limit: 4
    t.integer  "company_id",       limit: 4
    t.integer  "log_book_id",      limit: 4
    t.integer  "bank_type_id",     limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "journal_entries", ["bank_type_id"], name: "index_journal_entries_on_bank_type_id", using: :btree
  add_index "journal_entries", ["company_id"], name: "index_journal_entries_on_company_id", using: :btree
  add_index "journal_entries", ["log_book_id"], name: "index_journal_entries_on_log_book_id", using: :btree
  add_index "journal_entries", ["user_id"], name: "index_journal_entries_on_user_id", using: :btree

  create_table "journal_entry_transactions", force: :cascade do |t|
    t.string   "description",         limit: 255
    t.float    "debit",               limit: 24
    t.float    "credit",              limit: 24
    t.integer  "chart_of_account_id", limit: 4
    t.integer  "customer_vender_id",  limit: 4
    t.integer  "journal_entry_id",    limit: 4
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "journal_entry_transactions", ["chart_of_account_id"], name: "index_journal_entry_transactions_on_chart_of_account_id", using: :btree
  add_index "journal_entry_transactions", ["customer_vender_id"], name: "index_journal_entry_transactions_on_customer_vender_id", using: :btree
  add_index "journal_entry_transactions", ["journal_entry_id"], name: "index_journal_entry_transactions_on_journal_entry_id", using: :btree

  create_table "log_books", force: :cascade do |t|
    t.date     "transaction_date"
    t.string   "reference_no",     limit: 255
    t.integer  "cash_type_id",     limit: 4
    t.integer  "voucher_type_id",  limit: 4
    t.integer  "company_id",       limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "log_books", ["cash_type_id"], name: "index_log_books_on_cash_type_id", using: :btree
  add_index "log_books", ["company_id"], name: "index_log_books_on_company_id", using: :btree
  add_index "log_books", ["voucher_type_id"], name: "index_log_books_on_voucher_type_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.integer  "role",                   limit: 4
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "authentication_token",   limit: 255
    t.integer  "company_id",             limit: 4
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", using: :btree
  add_index "users", ["company_id"], name: "index_users_on_company_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "voucher_types", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "abbreviation", limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "working_periods", force: :cascade do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "company_id", limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "working_periods", ["company_id"], name: "index_working_periods_on_company_id", using: :btree

  add_foreign_key "bank_types", "cash_types"
  add_foreign_key "bank_types", "companies"
  add_foreign_key "chart_of_accounts", "chart_account_types"
  add_foreign_key "chart_of_accounts", "companies"
  add_foreign_key "customer_venders", "companies"
  add_foreign_key "journal_entries", "bank_types"
  add_foreign_key "journal_entries", "companies"
  add_foreign_key "journal_entries", "log_books"
  add_foreign_key "journal_entries", "users"
  add_foreign_key "journal_entry_transactions", "chart_of_accounts"
  add_foreign_key "journal_entry_transactions", "customer_venders"
  add_foreign_key "journal_entry_transactions", "journal_entries"
  add_foreign_key "log_books", "cash_types"
  add_foreign_key "log_books", "companies"
  add_foreign_key "log_books", "voucher_types"
  add_foreign_key "users", "companies"
  add_foreign_key "working_periods", "companies"
end
