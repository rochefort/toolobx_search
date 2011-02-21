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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101223094232) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "crawl_id"
    t.integer  "project_count"
  end

  add_index "categories", ["crawl_id"], :name => "index_categories_on_crawl_id"

  create_table "crawls", :force => true do |t|
    t.datetime "start_at"
    t.datetime "end_at"
    t.float    "processing_time"
    t.boolean  "result"
    t.integer  "category_count"
    t.integer  "project_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.string   "project_link"
    t.integer  "score"
    t.integer  "watcher_count"
    t.integer  "fork_count"
    t.integer  "gem_dl_count"
    t.integer  "current_dl_count"
    t.string   "description"
    t.string   "last_commit"
    t.string   "commit_link"
    t.string   "source_link"
    t.string   "web_link"
    t.string   "rdoc_link"
    t.string   "wiki_link"
    t.string   "gem_link"
    t.string   "gem_name"
    t.string   "current_version"
    t.integer  "crawl_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["crawl_id"], :name => "index_projects_on_crawl_id"

  create_table "scores", :force => true do |t|
    t.integer  "score"
    t.integer  "watcher_count"
    t.integer  "fork_count"
    t.integer  "gem_dl_count"
    t.integer  "current_dl_count"
    t.integer  "crawl_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "scores", ["crawl_id"], :name => "index_scores_on_crawl_id"

end
