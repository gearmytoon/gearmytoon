class ItemSocketImporter

  def initialize(wowarmory_item_id)
    @agent = Mechanize.new
    @page = @agent.get("http://www.thottbot.com/i#{wowarmory_item_id}")
  end

  def get_socket_bonuses
    @page.parser.css("span.itemsocket").map do |wowhead_link|
      wowhead_link.text.gsub("Socket Bonus: ", "")
    end.last || ""
  end
end