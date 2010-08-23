class MemberXmlProcessor
  def initialize(document)
    @document = document
  end
  
  def realm
    if @document.at("guildInfo/guildHeader")
      @document.at("guildInfo/guildHeader")['realm']
    else
      @document.at("arenaTeams/arenaTeam")['realm']
    end
  end
  
  def level_80_characters
    characters_hash.select{|character| character[:level] == "80"}
  end
  
  def characters_hash
    @document.xpath("//members/character").map do |character|
      {:level => character['level'], :name => character['name'], :realm => realm}.with_indifferent_access
    end
  end
  
  def find_more_characters(locale)
    characters_hash.each do |new_character_hash|
      unless Character.find_by_name_and_realm_and_locale(new_character_hash[:name], new_character_hash[:realm], locale)
        new_character = Character.find_or_create(new_character_hash[:name], new_character_hash[:realm], locale)
        Resque.enqueue(CharacterCrawlerJob, new_character.id)
      end
    end
    
  end
end