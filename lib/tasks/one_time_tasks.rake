desc "one time cleaning of the bad area's in the db"
task :destroy_bad_areas => :environment do
  ActiveRecord::Base.transaction do 
    bad_areas = Area.all.select {|area| area.name.blank? }
    items_to_reimport = bad_areas.map(&:items_dropped_in).flatten.map(&:wowarmory_item_id)
    puts "Reimporting the following items: #{items_to_reimport.join(',')}"
    puts "Destroying the following areas: #{bad_areas.map(&:id).join(',')}"
    bad_areas.map(&:destroy)

    items_to_reimport.each do |item|
      ItemImporter.import_from_wowarmory!(item)
    end
  end
end

desc "fix gem items in the db"
task :fix_gem_items => :environment do
  ActiveRecord::Base.transaction do
    gem_items =  Item.all.select {|item| !item.gem_color.nil? }
    gem_items.each do |gem_item|
      gem_item.update_attribute(:type, "GemItem")
    end
  end
end
