class GuildProgressImporter
  BASE_URL = "http://wow.guildprogress.com/Icecrown_25/"
  def initialize
    @agent = Mechanize.new
  end
  
  def process_untiL_page(page_number=2184)
    (1..page_number).to_a.each do |number|
      url = BASE_URL + number.to_s
      response = `curl #{url}`
      process_response(Nokogiri::HTML(response))
    end
  end
  
  def process_response(response)
    response.css(".chart .chartRow").each do |chart_row|
      locale = chart_row.css(".server .EU").blank? ? "us" : "eu"
      attributes = {:name => get_safe_text(chart_row, ".guild a"),
                    :locale => locale,
                    :realm => get_safe_text(chart_row, ".server a")}
      unless Guild.exists?(attributes[:name], attributes[:realm], attributes[:locale])
        guild = Guild.find_or_create(attributes[:name], attributes[:realm], attributes[:locale])
        Resque.enqueue(GuildCrawlerJob, guild.id)
      end
    end
  end
  
  def get_safe_text(element, selector)
    element.css(selector).inner_text.gsub("\302\240", "")
  end
end