class DeviseCreateParents < ActiveRecord::Migration
  def self.up
    create_table(:parents) do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable

      # t.encryptable
      # t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      # t.token_authenticatable


      t.timestamps
    end

    add_index :parents, :email,                :unique => true
    add_index :parents, :reset_password_token, :unique => true
    # add_index :parents, :confirmation_token,   :unique => true
    # add_index :parents, :unlock_token,         :unique => true
    # add_index :parents, :authentication_token, :unique => true
  end

  def self.down
    drop_table :parents
  end
end
