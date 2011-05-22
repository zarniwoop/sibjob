class CreateJobRecords < ActiveRecord::Migration
  def self.up
    create_table :job_records do |t|
      t.integer :job_id
      t.integer :performer_id
      t.integer :inspector_id

      t.timestamps
    end

    add_index :job_records, :performer_id
    add_index :job_records, :inspector_id
  end

  def self.down
    drop_table :job_records
  end
end
