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

ActiveRecord::Schema.define(version: 2022_10_25_204002) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assignments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "role_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["role_id"], name: "index_assignments_on_role_id"
    t.index ["user_id"], name: "index_assignments_on_user_id"
  end

  create_table "bags", force: :cascade do |t|
    t.bigint "bean_id"
    t.bigint "user_id"
    t.string "roast_level"
    t.date "roast_date"
    t.integer "price"
    t.decimal "weight"
    t.string "weight_unit"
    t.integer "rating"
    t.string "image_uri"
    t.boolean "favorite"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["bean_id"], name: "index_bags_on_bean_id"
    t.index ["user_id"], name: "index_bags_on_user_id"
  end

  create_table "beans", force: :cascade do |t|
    t.string "name"
    t.string "roaster"
    t.string "origin"
    t.string "flavor_notes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "image_uri"
    t.string "beans_uuid"
  end

  create_table "follows", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followed_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["followed_id"], name: "index_follows_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_follows_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_follows_on_follower_id"
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["post_id"], name: "index_likes_on_post_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "permissions", force: :cascade do |t|
    t.bigint "role_id", null: false
    t.string "permission"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["role_id"], name: "index_permissions_on_role_id"
  end

  create_table "posts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "caption"
    t.datetime "archived_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "post_uuid", null: false
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "phone"
    t.string "name"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "image_uri"
    t.string "username"
    t.datetime "archived_at"
    t.boolean "is_private", default: false, null: false
    t.string "bio"
    t.string "time_zone", default: "America/New_York", null: false
  end

  add_foreign_key "assignments", "roles"
  add_foreign_key "assignments", "users"
  add_foreign_key "likes", "posts"
  add_foreign_key "likes", "users"
  add_foreign_key "permissions", "roles"
  add_foreign_key "posts", "users"
end
