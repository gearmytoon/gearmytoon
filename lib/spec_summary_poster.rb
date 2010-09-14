class SpecSummaryPoster < CrossSitePoster

  def initialize(spec)
    @spec = spec
    @spec.summarize_all_characters
    @url = "/specs/#{@spec.id}/"
    super()
  end

  def form_with_data
    returning(Mechanize::Form.new(fake_form)) do |form|
      @spec.params_to_post.each do |param, value|
        field_name = "spec[#{param}]"
        form[field_name] = value
      end
    end
  end
  
end
