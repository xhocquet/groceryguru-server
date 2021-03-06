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

ActiveRecord::Schema.define(version: 20171218062918) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "coupons", force: :cascade do |t|
    t.datetime "expiration_date"
    t.datetime "store_begin_date"
    t.string "title"
    t.string "image_url"
    t.string "requirements"
    t.string "description"
    t.integer "type", default: 0
    t.integer "status", default: 1
    t.bigint "store_id"
    t.bigint "item_id"
    t.index ["item_id"], name: "index_coupons_on_item_id"
    t.index ["store_id"], name: "index_coupons_on_store_id"
  end

  create_table "item_groups", force: :cascade do |t|
    t.string "name"
    t.integer "usda_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "usda_id"
    t.bigint "group_id"
    t.bigint "submission_id"
    t.index ["group_id"], name: "index_items_on_group_id"
    t.index ["submission_id"], name: "index_items_on_submission_id"
  end

  create_table "receipts", force: :cascade do |t|
    t.string "text"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.string "pdf"
    t.datetime "date"
    t.bigint "store_id"
    t.integer "line_count", default: 0
    t.boolean "processed", default: false
    t.boolean "completed", default: false
    t.text "box_data"
    t.index ["store_id"], name: "index_receipts_on_store_id"
    t.index ["user_id"], name: "index_receipts_on_user_id"
  end

  create_table "store_locations", force: :cascade do |t|
    t.string "postal_code"
    t.bigint "store_id"
    t.bigint "submission_id"
    t.index ["store_id"], name: "index_store_locations_on_store_id"
    t.index ["submission_id"], name: "index_store_locations_on_submission_id"
  end

  create_table "stores", force: :cascade do |t|
    t.integer "postal_code"
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "submission_id"
    t.index ["name", "postal_code"], name: "index_stores_on_name_and_postal_code", unique: true
    t.index ["submission_id"], name: "index_stores_on_submission_id"
  end

  create_table "submissions", force: :cascade do |t|
    t.string "model_type"
    t.string "value"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.index ["user_id"], name: "index_submissions_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.text "raw"
    t.integer "count"
    t.integer "price_cents"
    t.string "price_currency", default: "USD", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "receipt_id"
    t.text "name"
    t.bigint "item_id"
    t.integer "line_number"
    t.text "weight"
    t.index ["item_id"], name: "index_transactions_on_item_id"
    t.index ["receipt_id"], name: "index_transactions_on_receipt_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
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
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.datetime "last_stats_update"
    t.boolean "admin", default: false
    t.string "authentication_token", limit: 30
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "receipts", "stores"
  add_foreign_key "receipts", "users"
  add_foreign_key "transactions", "receipts"
  add_foreign_key "transactions", "users"
end
