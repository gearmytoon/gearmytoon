# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

agent = WWW::Mechanize.new
api = Wowr::API.new()
agent.get("http://www.maxdps.com/hunter/survival.php")
slots = (1..17).to_a - [13] # hunters don't use maxdps's slot 13

slots.each do |slot|
  page = agent.get("http://www.maxdps.com/hunter/survival_read.php?slotID=#{slot}&tabID=0")
  puts "importing slot #{slot} from maxdps"
  page.parser.css(".ex .qu5").each do |wowhead_link|
    item_row = wowhead_link.parent.parent
    dps_element = item_row.css(".mainCell")
    wowhead_href = wowhead_link['href']
    wowarmory_id = wowhead_href.delete("http://www.wowhead.com/?item=")
    dps = dps_element.text
    wowarmory_item = api.get_item(wowarmory_id)
    Item.create!(:wowarmory_id => wowarmory_id, :dps => dps, :name => wowarmory_item.name, :quality => WowHelpers.quality_adjective_for(wowarmory_item))
  end
end

puts "backing up item list"
item_yaml_path = "#{RAILS_ROOT}/db/data/items.yml"
File.open(item_yaml_path, 'w') { |f| f.puts Item.all.to_yaml }

puts "backup saved to: #{item_yaml_path}"
