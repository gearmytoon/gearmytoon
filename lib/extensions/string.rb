class String
  def to_appropriate_type
    if self.match(/\A\d+\.\d+\z/)
      self.to_f
    elsif self.match(/\A\d+\z/)
      self.to_i
    else
      self
    end
  end
  
  def extract_bonuses
    returning({}) do |bonuses|
     self.split(" and ").each do |property|
        next if property.include?("%") #skip percent increases
        property.match(/\+?(\d+\%?)\s([^\z]+)/)
        next if($1.nil? || $2.nil?) #skip parsing minor run speed increase atm
        bonus_value = $1.to_i
        bonuses_name = $2.downcase.gsub(/\s/, "_").gsub(/_*rating_*/, "")
        bonuses_name = bonuses_name.starts_with?("mana") ? "mana_regen" : bonuses_name
        bonuses_name = bonuses_name == "critical_strike" ? "crit" : bonuses_name
        if bonuses_name == "all_stats"
          ['strength', 'agility', 'stamina', 'intellect', 'spirit'].each do |stat_name|
            bonuses[stat_name.to_sym] = bonus_value
          end
        else
          bonuses[bonuses_name.to_sym] = bonus_value
        end
      end
    end
  end
end