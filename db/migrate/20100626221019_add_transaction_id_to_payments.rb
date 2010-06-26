class AddTransactionIdToPayments < ActiveRecord::Migration
  def self.up
    add_column :payments, :transaction_id, :string
    add_index :payments, :transaction_id
  end

  def self.down
    remove_index :payments, :transaction_id
    remove_column :payments, :transaction_id
  end
end
