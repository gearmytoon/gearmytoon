class ItemSource < ActiveRecord::Base
  named_scope :for_items, Proc.new {|items| {:joins => :item, :conditions => ["item_sources.item_id IN (?)",items]}}
  belongs_to :item
end
