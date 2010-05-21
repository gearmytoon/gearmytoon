class CharacterRefresh < ActiveRecord::Base
  belongs_to :character
  acts_as_state_machine :initial => :new, :column => "status"
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
