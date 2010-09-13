require File.dirname(__FILE__) + '/../test_helper'

class ItemSummaryPosterTest < ActiveSupport::TestCase
  should "generate hashed form data" do
    item_popularity = Factory(:item_popularity, :average_gmt_score => 1, :percentage => 2, :spec => Factory(:survival_hunter_spec))
    item_summary_poster = ItemSummaryPoster.new(item_popularity.item)
    form_data = item_summary_poster.form_with_data
    assert_equal '2', form_data['item_popularities[0][percentage]']
    assert_equal '1', form_data['item_popularities[0][average_gmt_score]']
    assert_equal 'Survival', form_data['item_popularities[0][spec_name]']
    assert_equal 'Hunter', form_data['item_popularities[0][wow_class_name]']
  end
end
