class AddActiveToJob < ActiveRecord::Migration
  def self.up
    add_column :jobs, :active, :boolean, :default => 1
  end

  def self.down
    remove_column :jobs, :active
  end
end
