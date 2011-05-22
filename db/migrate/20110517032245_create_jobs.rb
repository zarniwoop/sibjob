class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.string :summary
      t.text :description
      t.integer :pointvalue
      t.integer :sibling_id

      t.timestamps
    end

    add_index :jobs, :sibling_id
  end

  def self.down
    remove_index :jobs
    drop_table :jobs
  end
end
