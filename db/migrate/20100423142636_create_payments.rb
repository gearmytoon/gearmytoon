class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.string :recipient_token
      t.string :caller_reference
      t.transaction_amount :decimal, :scale => 4, :percision => 2
      t.integer :purchaser_id
      t.string :status
      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
