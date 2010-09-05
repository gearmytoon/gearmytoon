require File.dirname(__FILE__) + '/../test_helper'

class ItemSummarizerTest < ActiveSupport::TestCase
  setup do
    Spec.destroy_all
  end
  should "generate a items summary for the percent of toons who use the item" do
    item = Factory(:item)
    hunter = Factory(:a_hunter, :name => "bar")
    shaman = Factory(:a_shaman, :name => "foo")
    Factory(:character_item, :character => hunter, :item => item)
    Factory(:character_item, :character => shaman, :item => item)
    assert_difference "ItemPopularity.count", 2 do
      ItemSummarizer.new(item.id).generate_summaries
    end
    hunter_ip = ItemPopularity.first(:conditions => {:spec_id => hunter.spec_id})
    shaman_ip = ItemPopularity.first(:conditions => {:spec_id => shaman.spec_id})
    assert_equal item, hunter_ip.item
    assert_equal item, shaman_ip.item
    assert_equal 50, hunter_ip.percentage
    assert_equal 50, shaman_ip.percentage
  end

  should "generate a items average gmt score summary" do
    item = Factory(:item)
    hunter_spec = Factory(:spec)
    hunter1 = Factory(:a_hunter, :spec => hunter_spec, :name => "bar")
    hunter1.gmt_score = 2500
    hunter1.send(:update_without_callbacks)
    hunter2 = Factory(:a_hunter, :spec => hunter_spec, :name => "foo")
    hunter2.gmt_score = 3500
    hunter2.send(:update_without_callbacks)
    Factory(:character_item, :character => hunter1, :item => item)
    Factory(:character_item, :character => hunter2, :item => item)
    assert_difference "ItemPopularity.count" do
      ItemSummarizer.new(item.id).generate_summaries
    end
    hunter_ip = ItemPopularity.first(:conditions => {:spec_id => hunter1.spec_id})
    assert_equal 3000, hunter_ip.average_gmt_score
  end

  should "only generate summaries for real specs" do
    item = Factory(:item)
    no_spec = Factory(:spec, :name => "")
    hunter = Factory(:character, :name => "bar", :spec => no_spec)
    Factory(:character_item, :character => hunter, :item => item)
    assert_no_difference "ItemPopularity.count" do
      ItemSummarizer.new(item.id).generate_summaries
    end
  end

  should "not generate summaries if the item is not used" do
    item = Factory(:item)
    hunter = Factory(:character, :name => "bar")
    assert_no_difference "ItemPopularity.count" do
      ItemSummarizer.new(item.id).generate_summaries
    end
  end

end
