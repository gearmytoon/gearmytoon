class WowArmoryMapper
  class << self
    def map(name, xpath, &block)
      @mappings ||= {}.with_indifferent_access
      mapper = xpath.is_a?(Hash) ? :get_hash : :get_single
      @mappings[name] = {:xpath => xpath, :mapper => mapper, :translate_with => block}
    end
    
    def map_many(name, paths, &block)
      @mappings[name] = {:xpath => paths, :mapper => :get_many, :translate_with => block}
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
        data = send(args[:mapper], args[:xpath])
        data = instance_exec(data, &args[:translate_with]) if args[:translate_with]
        result[name] = data
      end
    end
  end

  def get_single(xpath)
    value = get_value_at(@wowarmory_item_tooltip, xpath)
    return value unless value.nil?
    get_value_at(@wowarmory_item_info, xpath)
  end

  def get_many(hash)
    hash.map do |key, value|
      @wowarmory_item_tooltip.xpath(key).map do |element|
        get_values(element, value)
      end
    end.flatten
  end

  def get_hash(hash)
    key, value = hash.first
    element = @wowarmory_item_tooltip.at(key)
    return nil if element.nil?
    return get_values(element, value)
  end

  def get_mapping_strategy(input)
    case input
    when Hash
      Proc.new { |element, items_to_map|
        returning({}) do |hash|
          items_to_map.each do |k, v|
            val = get_value_at(element, v)
            hash[k.to_sym] = val if val
          end
        end
      }
    when Array
      Proc.new { |element, items_to_map|
        returning([]) do |array|
          items_to_map.each do |v|
            val = get_value_at(element, v)
            array << val if val
          end
        end
      }
    else
      Proc.new { |element, items_to_map| #this is weird
        returning([]) do |array|
          array << element.inner_html
        end
      }
    end
  end
  
  def get_values(element, items_to_map)
    return get_mapping_strategy(items_to_map).call(element, items_to_map)
  end
  
  def get_value_at(element, xpath)
    #######################
    # this is not ideal but nokogiri has a bug with xml parsing, it appears to cache by xpath so similar xpaths will incorrectly return the same result
    raw_xml = element.to_xml
    element = Nokogiri::XML(raw_xml)
    ############################
    value = element.at(xpath) ? element.at(xpath).inner_html.to_appropriate_type : nil
  end

end
