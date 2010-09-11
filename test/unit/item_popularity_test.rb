require File.dirname(__FILE__) + '/../test_helper'

class ItemPopularityTest < ActiveSupport::TestCase
  context "to_params" do
    should 'become params to post over the wire' do
      item_popularity = Factory(:item_popularity, :average_gmt_score => 1, 
                                                  :percentage => 2, :spec => Factory(:spec, :name => "Survival", :wow_class => WowClass.create_class!("Hunter")),
                                                  :item => Factory(:item, :wowarmory_item_id => 33))
      expected = {:average_gmt_score => 1, :percentage => 2, :spec_name => "Survival", :wow_class_name => "Hunter", :wowarmory_item_id => 33}
      assert_equal expected, item_popularity.params_to_post
    end
  end
end
