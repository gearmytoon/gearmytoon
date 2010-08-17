class RemoveAllEmblemSources < ActiveRecord::Migration
  def self.up
    ItemSource.delete_all('type = "EmblemSource"')
  end

  def self.down
  end
end
