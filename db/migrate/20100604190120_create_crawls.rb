class CreateCrawls < ActiveRecord::Migration
  def self.up
    create_table :crawls do |t|
      t.datetime :start_at
      t.datetime :end_at
      t.float    :processing_time
      t.boolean :result
      t.integer :category_count
      t.integer :project_count

      t.timestamps
    end
  end

  def self.down
    drop_table :crawls
  end
end
