module ItemInfoHelper
  RATING_STAT_DESCRIPTIONS = {:crit => "Improves critical strike rating", :haste => "Improves haste rating", :hit => "Improves hit rating", 
    :defense => "Increases defense rating", :dodge => "Increases your dodge rating", :parry => "Increases your parry rating", 
    :block_value => "Increases the block value of your shield"}
  def equipped_stat_string(stat_name, bonus)
    if RATING_STAT_DESCRIPTIONS.has_key?(stat_name)
      "#{RATING_STAT_DESCRIPTIONS[stat_name]} by #{bonus}"
    elsif stat_name == :mana_regen
      "Restores #{bonus} mana per 5 secs"
    else
      "Increases your #{stat_name.to_s.gsub("_", " ").downcase} by #{bonus}"
    end
  end
end