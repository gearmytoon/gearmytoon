class TradeSkill < ActiveRecord::Base
  def name
    wowarmory_name.gsub("trade_", "").camelize
  end
end
