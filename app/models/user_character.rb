class UserCharacter < ActiveRecord::Base
  belongs_to :subscriber, :class_name => "User"
  belongs_to :character
end
