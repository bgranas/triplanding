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

ActiveRecord::Schema.define(version: 20151113125756) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "destination_orders", force: :cascade do |t|
    t.integer  "trip_id"
    t.integer  "destination_id"
    t.integer  "order_authority", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "destination_orders", ["destination_id"], name: "index_destination_orders_on_destination_id", using: :btree
  add_index "destination_orders", ["trip_id"], name: "index_destination_orders_on_trip_id", using: :btree

  create_table "destinations", force: :cascade do |t|
    t.string   "name",                                                 null: false
    t.string   "google_place_id"
    t.decimal  "lat",                         precision: 11, scale: 8
    t.decimal  "lng",                         precision: 11, scale: 8
    t.string   "formatted_address"
    t.string   "street_address"
    t.string   "route"
    t.string   "intersection"
    t.string   "country"
    t.string   "country_iso_2"
    t.string   "administrative_area_level_1"
    t.string   "administrative_area_level_2"
    t.string   "administrative_area_level_3"
    t.string   "administrative_area_level_4"
    t.string   "administrative_area_level_5"
    t.string   "colloquial_area"
    t.string   "locality"
    t.string   "neighborhood"
    t.integer  "postal_code"
    t.string   "natural_feature"
    t.string   "airport"
    t.string   "park"
    t.string   "point_of_interest"
    t.string   "ward"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.string   "photoURL"
  end

  add_index "destinations", ["google_place_id"], name: "index_destinations_on_google_place_id", using: :btree

  create_table "identities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "leads", force: :cascade do |t|
    t.string   "email",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trips", force: :cascade do |t|
    t.string   "title"
    t.string   "permalink"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_trips", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "trip_id"
    t.boolean  "created_by_user",   default: false, null: false
    t.boolean  "favorited_by_user", default: false, null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "user_trips", ["user_id", "trip_id"], name: "index_user_trips_on_user_id_and_trip_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 50,                  null: false
    t.string   "encrypted_password",                 default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "name",                   limit: 20,                  null: false
    t.string   "hometown",               limit: 100
    t.string   "country_iso_3"
    t.string   "country",                limit: 50
    t.string   "blog_url",               limit: 75
    t.string   "profile_picture_path",   limit: 75
    t.string   "profile_url",            limit: 100,                 null: false
    t.boolean  "isAdmin",                            default: false, null: false
    t.string   "external_picture_url"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "destination_orders", "destinations"
  add_foreign_key "destination_orders", "trips"
  add_foreign_key "identities", "users"
end
