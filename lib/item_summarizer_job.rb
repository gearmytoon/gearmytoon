require 'resque/plugins/lock'

class ItemSummarizerJob
  extend Resque::Plugins::Lock

  @queue = :item_summarizer_jobs
  def self.perform(item_id)
    Item.find(item_id).summarize
  end
end
