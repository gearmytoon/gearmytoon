require File.dirname(__FILE__) + '/../test_helper'

class SpecTest < ActiveSupport::TestCase
  context "find_or_create" do
    should "find create by names" do
      assert_difference "Spec.count" do
        Spec.find_or_create("Restoration", "Shaman")
      end
    end
    should "not create by names if already exists" do
      Spec.find_or_create("Restoration", "Shaman")
      assert_no_difference "Spec.count" do
        Spec.find_or_create("Restoration", "Shaman")
      end
    end
    should "create by name if doesn't exist for class" do
      WowClass.create_class!("Druid")
      Spec.find_or_create("Restoration", "Shaman")
      assert_difference "Spec.count" do
        Spec.find_or_create("Restoration", "Druid")
      end
    end
  end
  
  context "css_icon_name" do
    should "downcase and underscorize with class name" do
      assert_equal "hunter_survival", Factory(:survival_hunter_spec).css_icon_name
      assert_equal "hunter_beast_mastery", Factory(:beast_mastery_hunter_spec).css_icon_name
      assert_equal "death_knight_blood", Factory(:death_knight_blood_spec).css_icon_name
    end
  end
  
  context "all_played_specs" do
    should "not find non standard specs" do
      expected = Factory(:survival_hunter_spec)
      Factory(:spec, :name => "foo")
      assert_equal [expected], Spec.all_played_specs
    end
    should "not find specs without a wow_class" do
      expected = Factory(:survival_hunter_spec)
      Factory(:spec, :wow_class => nil)
      assert_equal [expected], Spec.all_played_specs
    end
  end
  
  context "summarize_all_characters" do
    should "find average and std_devation all character gearscores" do
      spec = Factory(:survival_hunter_spec)
      hunter1 = Factory(:character, :spec => spec)
      hunter2 = Factory(:character, :spec => spec)
      hunter1.gmt_score = 3000
      hunter1.send(:update_without_callbacks)
      hunter2.gmt_score = 3500
      hunter2.send(:update_without_callbacks)
      spec.summarize_all_characters
      spec.reload
      assert_equal 3250, spec.average_gmt_score
      assert_equal "250.0", spec.gmt_score_standard_deviation.to_s
    end
    
  end
end
