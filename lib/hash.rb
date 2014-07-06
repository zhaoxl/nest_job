class Hash
  def compact(opts={})
    inject({}) do |new_hash, (k,v)|
      if !v.nil?
        new_hash[k] = opts[:recurse] && v.class == Hash ? v.compact(opts) : v
      end
      new_hash
    end
  end
end