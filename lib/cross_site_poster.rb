class CrossSitePoster
  LOGIN = "empty"
  PASSWORD = "f1ndm3g34r"
  
  def initialize
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
  
  def build_nested_form_for(objects, root)
    returning(Mechanize::Form.new(fake_form)) do |form|
      objects.each_with_index do |params, index|
        params.each do |param, value|
          field_name = "#{root}[#{index}][#{param}]"
          form[field_name] = value
        end
      end
    end
  end
  
  def post_summary_data(domain = "gearmytoon.com")
    @agent.send(:post_form, "http://#{domain}/#{@url}", form_with_data)
  end

end