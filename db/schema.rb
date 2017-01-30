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

ActiveRecord::Schema.define(version: 20170129154012) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "facebooks", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "fb_id"
    t.string   "access_token"
    t.integer  "friends_count"
    t.decimal  "friends_density"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.decimal  "avg_posts_sentiment"
    t.decimal  "words_per_post"
    t.decimal  "hashtags_per_post"
    t.boolean  "relationship_status"
    t.integer  "last_name_length"
    t.integer  "activties_length"
    t.integer  "favorites_count"
    t.text     "first_name"
    t.text     "last_name"
    t.decimal  "links_per_post"
    t.index ["user_id"], name: "index_facebooks_on_user_id", using: :btree
  end

  create_table "personalities", force: :cascade do |t|
    t.integer  "user_id"
    t.decimal  "extraversion"
    t.decimal  "agreeableness"
    t.decimal  "conscientiousness"
    t.decimal  "neuroticism"
    t.decimal  "openness"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.text     "fb_id"
    t.text     "first_name"
    t.text     "last_name"
    t.index ["user_id"], name: "index_personalities_on_user_id", using: :btree
  end

  create_table "products", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.string   "code"
    t.string   "image"
    t.decimal  "extraversion"
    t.decimal  "agreeableness"
    t.decimal  "conscientiousness"
    t.decimal  "neuroticism"
    t.decimal  "openness"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.decimal  "price"
    t.string   "source_url"
  end

  create_table "purchases", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.string   "quantity"
    t.string   "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_purchases_on_product_id", using: :btree
    t.index ["user_id"], name: "index_purchases_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
