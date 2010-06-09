class CharacterRefresh < ActiveRecord::Base
  belongs_to :character
  acts_as_state_machine :initial => :new, :column => "status"
  named_scope :active, :conditions => {:status => "new"}
  named_scope :recent, Proc.new{ {:conditions => ['created_at > ?', 5.minutes.ago.utc]} } #need to delay evaluation of this for tests
  state :new
  state :done
  
  event :loaded do
    transitions :to => :done, :from => :new
  end
  
  def found!
    loaded!
    character.loaded!
  end
  
  def not_found!
    loaded!
    character.unable_to_load!
  end
end
