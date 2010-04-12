class MaintainSupportForWowClasses < ActiveRecord::Migration
  def self.up
    WowClass.all.each do |wow_class|
      wow_class.update_attribute(:type, wow_class.name.gsub(/\s/,""))
    end
  end

  def self.down
  end
end
