class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name
      t.string :project_link
      t.integer :score
      t.integer :watcher_count
      t.integer :fork_count
      t.integer :gem_dl_count
      t.integer :current_dl_count
      t.string :description
      t.string :last_commit
      t.string :commit_link
      t.string :source_link
      t.string :web_link
      t.string :rdoc_link
      t.string :wiki_link
      t.string :gem_link
      t.string :gem_name
      t.string :current_version
      t.integer :crawl_id
      t.integer :category_id

      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
