class Guild < ActiveRecord::Base
  has_many :characters
  
  def self.exists?(name, realm, locale)
    Guild.find_by_name_and_realm_and_locale(name, realm, locale)
  end
  
  def self.find_or_create(name, realm, locale)
    guild = Guild.find_or_create_by_name_and_realm_and_locale(name, realm, locale)
  end
end
