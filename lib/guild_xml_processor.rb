class GuildXmlProcessor
  def initialize(document)
    @document = document
  end
  
  def realm
    @document.at("guildInfo/guildHeader")['realm']
  end
  
  def level_80_characters
    characters_hash.select{|character| character[:level] == "80"}
  end
  
  def characters_hash
    @document.xpath("//guild/members/character").map do |character|
      {:level => character['level'], :name => character['name'], :guild => realm}.with_indifferent_access
    end
  end
end