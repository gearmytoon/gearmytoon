desc "make sample item popularities"
task :sample_popularities => :environment do
  items = Item.all(:limit => 52, :conditions => {:quality => 'epic', :slot => ItemImporter::SLOT_CONVERSION.values})
  Spec.all_played_specs.each do |spec|
    puts "Generating popularities for: #{spec.name} #{spec.wow_class.name}"
    items.each do |item|
      average_gmt_score = rand() * 10000
      percentage = rand() * 100
      spec.item_popularities.create(:average_gmt_score => average_gmt_score, :percentage => percentage, :item => item)
    end
  end
end