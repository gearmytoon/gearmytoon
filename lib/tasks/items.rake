desc "build the item list from max dps"
task :build_item_list_from_max_dps => :environment do
  MaxDpsImporter.build_all_lists
end

desc "build an item list from max dps for a specific constant"
task :build_a_specific_list_from_max_dps => :environment do
  max_dps_importer = MaxDpsImporter.new(ENV['klass'])
  max_dps_importer.import_from_max_dps
end

desc "import a text file via wow armory"
task :import_a_items_text_file => :environment do
  FromTextFileItemImporter.import!("db/data/items/#{ENV['NAME']}")
end

desc "import all item text files via wow armory"
task :import_all_item_text_files => :environment do
  Dir['db/data/items/*.txt'].each do |file|
    FromTextFileItemImporter.import!("db/data/items/#{File.basename(file)}")
  end
end

desc "import all items that match a term from wow armory"
task :import_by_wow_armory_search => :environment do
  ItemImporter.import_all_items_that_contain!(ENV['TERM'])
end

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