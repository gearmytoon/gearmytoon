class RemoveUnusedColumnsFromPayments < ActiveRecord::Migration
  def self.up
    remove_column :payments, :recipient_token
    remove_column :payments, :caller_reference
    remove_column :payments, :caller_token
  end

  def self.down
    add_column :payments, :caller_token, :string
    add_column :payments, :caller_reference, :string
    add_column :payments, :recipient_token, :string
  end
end
