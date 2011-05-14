class DeviseCreateSiblings < ActiveRecord::Migration
  def self.up
    create_table(:siblings) do |t|
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

    add_index :siblings, :email,                :unique => true
    add_index :siblings, :reset_password_token, :unique => true
    # add_index :siblings, :confirmation_token,   :unique => true
    # add_index :siblings, :unlock_token,         :unique => true
    # add_index :siblings, :authentication_token, :unique => true
  end

  def self.down
    drop_table :siblings
  end
end
