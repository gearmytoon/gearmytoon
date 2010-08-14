require 'resque/plugins/lock'
class FindItemJob
  extend Resque::Plugins::Lock

  @queue = :find_item_jobs

  def self.perform(wowarmory_item_id)
    ItemImporter.import_from_wowarmory!(wowarmory_item_id)
  end
end