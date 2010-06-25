class UpdatePaymentsForSimplePay < ActiveRecord::Migration
  def self.up
    add_column :payments, :raw_data, :text
  end

  def self.down
    remove_column :payments, :raw_data
  end
end
