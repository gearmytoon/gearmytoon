class String
  def extract_bonuses
    returning({}) do |bonuses|
     self.split(" and ").each do |property|
        next if property.include?("%") #skip percent increases
        property.match(/\+?(\d+\%?)\s([^\z]+)/)
        bonus_value = $1.to_i
        bonuses_name = $2.downcase.gsub(/\s/, "_").gsub(/_*rating_*/, "")
        bonuses_name = bonuses_name.starts_with?("mana") ? "mana_regen" : bonuses_name
        bonuses_name = bonuses_name == "critical_strike" ? "crit" : bonuses_name
        bonuses[bonuses_name.to_sym] = bonus_value
      end
    end
  end
end