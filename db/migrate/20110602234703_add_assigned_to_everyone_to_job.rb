class AddAssignedToEveryoneToJob < ActiveRecord::Migration
  def self.up
    add_column :jobs, :assigned_to_everyone, :boolean, :default => 0
  end

  def self.down
    remove_column :jobs, :assigned_to_everyone
  end
end
