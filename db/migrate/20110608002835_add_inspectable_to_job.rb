class AddInspectableToJob < ActiveRecord::Migration
  def self.up
    add_column :jobs, :inspectable, :boolean, :default => 1
  end

  def self.down
    remove_column :jobs, :inspectable
  end
end
