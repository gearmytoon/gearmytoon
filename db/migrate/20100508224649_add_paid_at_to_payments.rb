class AddPaidAtToPayments < ActiveRecord::Migration
  def self.up
    add_column :payments, :paid_at, :datetime
  end

  def self.down
    remove_column :payments, :paid_at
  end
end
