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

ActiveRecord::Schema.define(version: 2018_11_20_140452) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "guests", force: :cascade do |t|
    t.bigint "restaurant_id"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["first_name"], name: "index_guests_on_first_name"
    t.index ["last_name"], name: "index_guests_on_last_name"
    t.index ["restaurant_id"], name: "index_guests_on_restaurant_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.bigint "guest_id"
    t.bigint "restaurant_id"
    t.string "status", default: "pending"
    t.datetime "start_time"
    t.integer "covers"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guest_id"], name: "index_reservations_on_guest_id"
    t.index ["restaurant_id"], name: "index_reservations_on_restaurant_id"
  end

  create_table "restaurants", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "email"
    t.string "location"
    t.string "opening_hour"
    t.string "closing_hour"
    t.integer "created_by_id"
    t.boolean "archive", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location"], name: "index_restaurants_on_location"
    t.index ["name"], name: "index_restaurants_on_name"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone"
    t.string "address"
    t.string "password_digest"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "guests", "restaurants"
  add_foreign_key "reservations", "guests"
  add_foreign_key "reservations", "restaurants"
end
