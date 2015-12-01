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

ActiveRecord::Schema.define(version: 20151201143348) do

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

  create_table "destination_photos", force: :cascade do |t|
    t.integer  "destination_id"
    t.string   "panoramio_photo_id"
    t.integer  "height"
    t.integer  "width"
    t.decimal  "lat"
    t.decimal  "lng"
    t.string   "photo_title"
    t.string   "photo_url"
    t.string   "photo_file_url"
    t.string   "photo_size"
    t.string   "owner_url"
    t.string   "owner_name"
    t.string   "owner_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "destination_photos", ["destination_id"], name: "index_destination_photos_on_destination_id", using: :btree

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

  create_table "segments", force: :cascade do |t|
    t.integer  "route_id"
    t.integer  "trip_id"
    t.string   "path"
    t.decimal  "duration"
    t.decimal  "distance"
    t.boolean  "is_imperial"
    t.decimal  "cost"
    t.string   "currency"
    t.decimal  "cost_native"
    t.string   "currency_native"
    t.string   "kind"
    t.string   "agency_name"
    t.string   "agency_url"
    t.string   "airport_s_code"
    t.string   "airport_t_code"
    t.string   "s_name"
    t.string   "t_name"
    t.string   "flight_path_lat"
    t.string   "flight_path_lng"
    t.boolean  "is_major"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "segments", ["trip_id"], name: "index_segments_on_trip_id", using: :btree

  create_table "trips", force: :cascade do |t|
    t.string   "title"
    t.string   "permalink"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "cities"
    t.integer  "countries"
    t.integer  "distance"
    t.integer  "departure_city_destination_id"
    t.integer  "return_city_destination_id"
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
  add_foreign_key "destination_photos", "destinations"
  add_foreign_key "identities", "users"
  add_foreign_key "segments", "trips"
end
