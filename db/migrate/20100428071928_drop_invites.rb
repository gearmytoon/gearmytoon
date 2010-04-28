class DropInvites < ActiveRecord::Migration
  def self.up
    drop_table :invites
  end

  def self.down
  end
end
