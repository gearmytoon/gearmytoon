require File.dirname(__FILE__) + '/../test_helper'

class SpecSummaryPosterTest < ActiveSupport::TestCase
  should "generate hashed form data" do
    spec = Factory(:survival_hunter_spec)
    hunter1 = Factory(:character, :spec => spec)
    hunter2 = Factory(:character, :spec => spec)
    hunter1.gmt_score = 3000
    hunter1.send(:update_without_callbacks)
    hunter2.gmt_score = 3500
    hunter2.send(:update_without_callbacks)
    spec_summary_poster = SpecSummaryPoster.new(spec)
    form_data = spec_summary_poster.form_with_data
    assert_equal '3250', form_data['spec[average_gmt_score]']
    assert_equal '250.0', form_data['spec[gmt_score_standard_deviation]']
    assert_equal 'Survival', form_data['spec[spec_name]']
    assert_equal 'Hunter', form_data['spec[wow_class_name]']
  end
end
