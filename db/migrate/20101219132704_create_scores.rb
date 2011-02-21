class CreateScores < ActiveRecord::Migration
  def self.up
    create_table :scores do |t|
      t.integer :score
      t.integer :watcher_count
      t.integer :fork_count
      t.integer :gem_dl_count
      t.integer :current_dl_count
      t.integer :crawl_id
      t.integer :project_id

      t.timestamps
    end
  end

  def self.down
    drop_table :scores
  end
end
