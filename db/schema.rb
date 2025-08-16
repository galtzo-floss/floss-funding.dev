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

ActiveRecord::Schema[8.0].define(version: 2025_08_15_201500) do
  create_table "accounts", force: :cascade do |t|
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_accounts_on_email", unique: true
  end

  create_table "activation_events", force: :cascade do |t|
    t.integer "activation_key_id", null: false
    t.integer "account_id"
    t.string "library_name"
    t.integer "donation_amount"
    t.string "donation_currency", default: "USD", null: false
    t.string "ip_address"
    t.integer "flags", default: 0, null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["account_id"], name: "index_activation_events_on_account_id"
    t.index ["activation_key_id"], name: "index_activation_events_on_activation_key_id"
  end

  create_table "activation_keys", force: :cascade do |t|
    t.string "namespace", null: false
    t.string "key", null: false
    t.string "ecosystem", null: false
    t.integer "activation_event_count", default: 0, null: false
    t.integer "flags", default: 0, null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "project_name"
    t.string "project_url"
    t.index ["namespace", "key"], name: "index_activation_keys_on_namespace_and_key", unique: true
  end

  create_table "identities", force: :cascade do |t|
    t.integer "account_id", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_identities_on_account_id"
    t.index ["email"], name: "index_identities_on_email", unique: true
  end

  add_foreign_key "activation_events", "accounts"
  add_foreign_key "activation_events", "activation_keys"
  add_foreign_key "identities", "accounts"
end
