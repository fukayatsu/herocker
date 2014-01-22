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

ActiveRecord::Schema.define(version: 20140122122003) do

  create_table "images", force: true do |t|
    t.string   "name"
    t.string   "original_filename"
    t.string   "extname"
    t.binary   "content"
    t.string   "content_type"
    t.integer  "size"
    t.boolean  "protected",         default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "images", ["name"], name: "index_images_on_name"
  add_index "images", ["protected"], name: "index_images_on_protected"

end
