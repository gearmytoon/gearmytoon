desc "build the item list from wow armory"
task :build_item_list_from_max_dps => :environment do
  MaxDpsImporter.build_all_lists
end