class ItemSummaryPoster
  LOGIN = "empty"
  PASSWORD = "f1ndm3g34r"

  def initialize(item)
    @item = item
    @agent = Mechanize.new
    @agent.auth(LOGIN, PASSWORD)
  end

  def fake_form
    node = {}
    class << node
      def search(*args); []; end
    end
    node['method'] = 'POST'
    node['enctype'] = 'application/x-www-form-urlencoded'
    node
  end

  def form_with_data
    form = Mechanize::Form.new(fake_form)
    @item.popularity_params.each_with_index do |item_popularity_params, index|
      item_popularity_params.each do |item_popularity_param, value|
        field_name = "item_popularities[#{index}][#{item_popularity_param}]"
        form[field_name] = value
      end
    end
    form
  end
  
  def post_summary_data(domain = "gearmytoon.com")
    url = "http://#{domain}/items/#{@item.wowarmory_item_id}/update_used_by/"
    @agent.send(:post_form, url, form_with_data)
  end
end
