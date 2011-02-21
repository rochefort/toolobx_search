class AddCrawlIdToCategory < ActiveRecord::Migration
  def self.up
    add_column :categories, :crawl_id, :integer
  end

  def self.down
    remove_column :categories, :crawl_id
  end
end
