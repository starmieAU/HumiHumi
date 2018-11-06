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

ActiveRecord::Schema.define(version: 20181105150142) do

  create_table "books", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "uid"
    t.string   "title"
    t.string   "subtitle"
    t.string   "authors"
    t.string   "publisher"
    t.string   "published_date"
    t.string   "description"
    t.string   "image_url"
    t.string   "isbn_10"
    t.string   "isbn_13"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "reviews", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "book_id"
    t.boolean  "favorite",                     default: false, null: false
    t.integer  "read_status"
    t.integer  "emotion"
    t.integer  "point"
    t.string   "u_article"
    t.integer  "u_point"
    t.string   "review_10_char"
    t.text     "review_text",    limit: 65535
    t.boolean  "review_caution"
    t.text     "user_memo",      limit: 65535
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.index ["book_id"], name: "index_reviews_on_book_id", using: :btree
    t.index ["user_id", "book_id", "favorite"], name: "index_reviews_on_user_id_and_book_id_and_favorite", unique: true, using: :btree
    t.index ["user_id"], name: "index_reviews_on_user_id", using: :btree
  end

  create_table "user_relations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "to_user_id"
    t.boolean  "follow"
    t.boolean  "mute"
    t.boolean  "block"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["to_user_id"], name: "index_user_relations_on_to_user_id", using: :btree
    t.index ["user_id"], name: "index_user_relations_on_user_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "prof_name"
    t.text     "prof_greeting", limit: 65535
    t.string   "uid"
    t.string   "provider"
    t.string   "auth_name"
    t.string   "auth_nickname"
    t.string   "image_url"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_foreign_key "reviews", "books"
  add_foreign_key "reviews", "users"
  add_foreign_key "user_relations", "users"
  add_foreign_key "user_relations", "users", column: "to_user_id"
end
