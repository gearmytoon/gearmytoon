class ItemSummarizer
  def initialize(item_id)
    @item = Item.find(item_id)
  end
  
  def generate_summaries
    all_specs = Spec.all_played_specs
    all_specs.each do |spec|
      used_by_count = @item.character_items.used_by(spec).count
      next if used_by_count == 0
      total_used = @item.character_items.count
      percentage = (used_by_count.to_f / total_used)*100
      gmt_scores = Character.all(:joins => :character_items, :conditions => ['character_items.item_id = ?', @item.id], :select => :gmt_score).map(&:gmt_score)
      total_gmt_score = gmt_scores.sum
      average_gmt_score = total_gmt_score / used_by_count
      @item.item_popularities.create!(:spec => spec, :percentage => percentage, :average_gmt_score => average_gmt_score)
    end
  end
  
end
