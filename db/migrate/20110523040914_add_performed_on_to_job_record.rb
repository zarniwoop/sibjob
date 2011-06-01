class AddPerformedOnToJobRecord < ActiveRecord::Migration
  def self.up
    add_column :job_records, :performed_on, :date
  end

  def self.down
    remove_column :job_records, :performed_on
  end
end
