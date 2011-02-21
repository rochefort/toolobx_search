class AddIndexScore < ActiveRecord::Migration
  def self.up
    add_index :scores, :crawl_id
  end

  def self.down
    remove_index :scores, :crawl_id
  end
end
