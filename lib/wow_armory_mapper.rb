class WowArmoryMapper
  class << self
    def map(name, xpath, &block)
      @mappings ||= {}.with_indifferent_access
      @mappings[name] = {:xpath => xpath, :translate_with => block}
    end
    def map_many(name, paths)
      @mappings[name] = {:xpath => paths, :many => true}
    end
    def add_mapping(name, value)
      @mappings ||= {}.with_indifferent_access
      @mappings[name] = value
    end
    def mappings
      @mappings
    end
  end

  def mapped_options
    returning({}) do |result|
      self.class.mappings.each do |name, args|
        if args[:xpath].is_a?(Hash)
          if args[:many]
            data = get_many(args[:xpath])
          else
            data = get_hash(args[:xpath])
          end
        else
          data = get_value_at(@wowarmory_item_tooltip, args[:xpath])
          data = get_value_at(@wowarmory_item_info, args[:xpath]) if data.nil?
        end
        data = instance_exec(data, &args[:translate_with]) if args[:translate_with]
        result[name] = data
      end
    end
  end

  def get_hash(hash)
    key, value = hash.first
    element = @wowarmory_item_tooltip.at(key)
    return nil if element.nil?
    returning({}) do |hash|
      value.each do |key, value|
        val = get_value_at(element, value)
        hash[key.to_sym] = val if val
      end
    end
  end
  
  def get_many(hash)
    hash.map do |key, value|
      @wowarmory_item_tooltip.xpath(key).map do |element|
        returning({}) do |hash|
          value.each do |key, value|
            val = get_value_at(element, value)
            hash[key.to_sym] = val if val
          end
        end
      end
    end.flatten
  end

  def get_value_at(element, xpath)
    value = element.at(xpath) ? element.at(xpath).inner_html.to_appropriate_type : nil
  end

end
