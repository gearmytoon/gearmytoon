class ItemSummaryPoster < CrossSitePoster

  def initialize(item)
    @item = item
    @url = "/items/#{@item.wowarmory_item_id}/update_used_by/"
    super()
  end

  def form_with_data
    build_nested_form_for(@item.popularity_params, "item_popularities")
  end
  
end
