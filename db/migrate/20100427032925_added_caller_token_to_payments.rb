class AddedCallerTokenToPayments < ActiveRecord::Migration
  def self.up
    add_column :payments, :caller_token, :string
  end

  def self.down
    remove_column :payments, :caller_token
  end
end
