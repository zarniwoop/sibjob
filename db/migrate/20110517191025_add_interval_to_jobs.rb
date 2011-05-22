class AddIntervalToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :interval, :string
  end

  def self.down
    remove_column :jobs, :interval
  end
end
