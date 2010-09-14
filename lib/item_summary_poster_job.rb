require 'resque/plugins/lock'

class ItemSummaryPosterJob
  extend Resque::Plugins::Lock

  @queue = :item_summary_poster_jobs
  def self.perform(item_id)
    item = Item.find(item_id)
    ItemSummaryPoster.new(item).post_summary_data
    sleep(5)
  end
end
