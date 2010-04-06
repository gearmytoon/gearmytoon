class FromTextFileItemImporter
  def self.import_all!
    all_files = Dir["#{RAILS_ROOT}/db/data/items"]
    all_files.map {|a_file| FromTextFileItemImporter.import!(a_file)}
  end
  def self.import!(file_name)
    puts "Importing #{file_name}"
    wowarmory_item_ids = File.readlines(file_name)
    wowarmory_item_ids.map(&:chomp!)
    wowarmory_item_ids.each do |wowarmory_item_id|
      ItemImporter.import_from_wowarmory!(wowarmory_item_id)
    end
  end
end