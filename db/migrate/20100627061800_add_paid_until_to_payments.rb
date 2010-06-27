class AddPaidUntilToPayments < ActiveRecord::Migration
  def self.up
    add_column :payments, :paid_until, :datetime
    add_column :payments, :plan_type, :string
    remove_column :payments, :paid_at
  end

  def self.down
    add_column :payments, :paid_at, :datetime
    remove_column :payments, :plan_type
    remove_column :payments, :paid_until
  end
end
