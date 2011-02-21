class AddProjectCountToCategory < ActiveRecord::Migration
  def self.up
    add_column :categories, :project_count, :integer
  end

  def self.down
    remove_column :categories, :project_count
  end
end
