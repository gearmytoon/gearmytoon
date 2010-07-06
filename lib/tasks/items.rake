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

desc "import all items"
task :import_all_items => :environment do
  p "Started: #{Time.now}"
  (36000..51586).to_a.each do |wow_armory_id|
    p wow_armory_id
    ItemImporter.import_from_wowarmory!(wow_armory_id)
  end
  p "Ended: #{Time.now}"
end
