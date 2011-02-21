class AddIndexProject < ActiveRecord::Migration
  def self.up
    add_index :projects, :crawl_id
  end

  def self.down
    remove_index :projects, :crawl_id
  end
end
