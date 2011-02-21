class AddIndexCategory < ActiveRecord::Migration
  def self.up
    add_index :categories, :crawl_id
  end

  def self.down
    remove_index :categories, :crawl_id
  end
end
