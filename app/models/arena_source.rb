class ArenaSource < ItemSource
  named_scope :all # ActiveRecord::Base.all wasn't returning a assosication proxy, instead was returning an array
end
