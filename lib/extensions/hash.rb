class Hash
  def subtract_values(other_hash)
    returning({}) do |new_hash|
      self.each do |key, value|
        other_hash_value = other_hash.has_key?(key) ? other_hash[key] : 0.0
        new_hash[key] = value - other_hash_value
      end
      values_unique_to_other_hash = other_hash.except(*self.keys)
      values_unique_to_other_hash.each {|key, value| new_hash[key] = -value }
    end
  end
  
  def add_values(other_hash)
    returning({}) do |new_hash|
      self.each do |key, value|
        other_hash_value = other_hash.has_key?(key) ? other_hash[key] : 0.0
        new_hash[key] = value + other_hash_value
      end
      values_unique_to_other_hash = other_hash.except(*self.keys)
      values_unique_to_other_hash.each {|key, value| new_hash[key] = value }
    end
  end
end