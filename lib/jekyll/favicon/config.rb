module Jekyll
  module Favicon
    # provide common functionality methods
    module Config
      def self.transform(config, key: nil, base_values: {}, replace_values: {},
                         ensure_one: false)
        transformed = case config
                      when Hash then transform_hash config, key
                      when Array then transform_array config, key
                      else []
                      end
        transformed = [{}] if transformed.empty? && ensure_one
        transformed.collect do |custom_values|
          Utils.merge(Utils.merge(base_values, custom_values), replace_values)
        end
      end

      def self.transform_array(config, key)
        config.collect { |item| transform_hash item, key }.flatten
      end

      def self.transform_string(text, key)
        return { key => text } if key
        return {} if text.empty?
        { text => true }
      end

      def self.transform_hash(item, key)
        return [] if item.nil? || item.empty?
        return [item] if key.nil? || item.key?(key)
        item.collect do |item_key, value|
          transform_value(value).update(key => item_key) unless value == 'skip'
        end.compact
      end

      def self.transform_value(value)
        case value
        when String then transform_string value, nil
        when Hash then value
        else {}
        end
      end
    end
  end
end
