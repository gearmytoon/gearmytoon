class ItemSource < ActiveRecord::Base
  named_scope :for_items, Proc.new {|items| {:include => :item, :conditions => {:item_id => items}}}
  belongs_to :item
end
