desc "sync all item popularities to production"
task :sync_all_item_popularities_with_production => :environment do
  Item.find_in_batches(:select => :id) do |group|
    group.each do |item|
      Resque.enqueue(ItemSummaryPosterJob, item.id)
    end
  end
end

desc "sync all spec summary data production"
task :sync_all_specs_with_production => :environment do
  Spec.all_played_specs.each do |spec|
    poster = SpecSummaryPoster.new(spec)
    poster.post_summary_data
  end
end
