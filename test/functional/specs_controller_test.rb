require File.dirname(__FILE__) + '/../test_helper'

class SpecsControllerTest < ActionController::TestCase
  context "get show" do
    should "respond with success" do
      spec = Factory(:survival_hunter_spec)
      get :show, :id => spec.id, :scope => spec.wow_class.id
      assert_response :success
    end

    should "filter out tabards" do
      spec = Factory(:survival_hunter_spec)
      Factory(:item_popularity, :spec => spec, :item => Factory(:tabard))
      get :show, :id => spec.id, :scope => spec.wow_class.id
      assert_select ".item_popularity", :count => 0
    end

    should "filter out shirts" do
      spec = Factory(:survival_hunter_spec)
      Factory(:item_popularity, :spec => spec, :item => Factory(:shirt))
      get :show, :id => spec.id, :scope => spec.wow_class.id
      assert_select ".item_popularity", :count => 0
    end

    should "display specs_name" do
      spec = Factory(:survival_hunter_spec)
      get :show, :id => spec.id, :scope => spec.wow_class.id
      assert_select ".spec_name", :text => "Survival"
      assert_select ".wow_class_name", :text => "Hunter's"
    end

    should "paginate item popularities" do
      spec = Factory(:survival_hunter_spec)
      26.times{Factory(:item_popularity, :spec => spec)}
      get :show, :id => spec.id, :scope => spec.wow_class.id
      assert_select ".item_popularity", :count => 25
    end
    
    should "show item popularity data" do
      spec = Factory(:survival_hunter_spec)
      Factory(:item_popularity, :spec => spec, :item => Factory(:item, :name => "Foo's Bar"), :percentage => 1, :average_gmt_score => 3232)
      get :show, :id => spec.id, :scope => spec.wow_class.id
      assert_select ".with_tooltip", :text => "Foo's Bar"
      assert_select ".percentage", :text => "1"
      assert_select ".average_gmt_score", :text => "3232"
    end

  end
  
  context "post create_or_update" do
    setup do
      @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("#{ItemSummaryPoster::LOGIN}:#{ItemSummaryPoster::PASSWORD}")
      WowClass.delete_all
    end

    should "require correct basic authorization" do
      @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("empty:wtfbbq")
      WowClass.create_class!("Hunter")
      post :create_or_update, :spec => {:average_gmt_score => "1", :gmt_score_standard_deviation => "3.3333", :spec_name => "Survival", :wow_class_name => "Hunter"}
      assert_response 401
    end

    should "create spec if does not exist" do
      WowClass.create_class!("Hunter")
      assert_difference "Spec.count" do
        post :create_or_update, :spec => {:average_gmt_score => "1", :gmt_score_standard_deviation => "3.3333", :spec_name => "Survival", :wow_class_name => "Hunter"}
      end
      assert_equal 1, Spec.last.average_gmt_score
      assert_equal "3.33", Spec.last.gmt_score_standard_deviation.to_s
      assert_equal "Survival", Spec.last.name
      assert_equal "Hunter", Spec.last.wow_class.name
    end

    should "update spec" do
      wow_class = WowClass.create_class!("Shaman")
      spec = Factory(:spec, :name => "Restoration", :wow_class => wow_class)
      assert_no_difference "Spec.count" do
        post :create_or_update, :spec => {:average_gmt_score => "1", :gmt_score_standard_deviation => "3.3333", :spec_name => "Restoration", :wow_class_name => "Shaman"}
      end
      spec.reload
      assert_equal 1, spec.average_gmt_score
      assert_equal "3.33", spec.gmt_score_standard_deviation.to_s
      assert_equal "Restoration", spec.name
      assert_equal "Shaman", spec.wow_class.name
    end

  end
end
