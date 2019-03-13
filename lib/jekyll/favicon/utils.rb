module Jekyll
  module Favicon
    # provide common functionality methods
    module Utils
      def self.normalize(attributes, key: nil)
        case attributes
        when String then normalize_string attributes, key
        when Hash then normalize_hash attributes, key
        when Array then normalize_array attributes, key
        else [attributes]
        end.flatten.compact.reject(&:empty?)
      end

      def self.normalize_string(attributes, key)
        attributes.empty? ? [] : [{ (key || attributes) => attributes }]
      end

      def self.normalize_hash(attributes, key)
        return [attributes] unless key
        attributes.collect do |attribute_name, attribute_value|
          { key => attribute_name }.merge case attribute_value
                                          when Hash then attribute_value
                                          else { attribute_value => true }
                                          end
        end
      end

      def self.normalize_array(attributes, key)
        attributes.collect { |attribute| normalize attribute, key: key }
      end

      def self.merge(base, custom, override: false)
        return base unless custom
        return base.merge custom if override
        deeply_merge_hashes_and_arrays base, custom
      end

      def self.deeply_merge_hashes_and_arrays(base, mask = {})
        deeply_merge_hashes_and_arrays! base.dup, mask
      end

      def self.deeply_merge_hashes_and_arrays!(base, mask)
        base.merge!(mask) { |_key, old_val, new_val| which? old_val, new_val }
        if all?(Hash, base, mask) && base.default_proc.nil?
          base.default_proc = mask.default_proc
        end
        base.each { |key, val| base[key] = val.dup if frozen_and_can_dup? val }
      end

      def self.all?(klass, *values)
        values.all? { |value| value.is_a? klass }
      end

      def self.which?(*values)
        if values.last.nil? then values.first
        elsif all?(Array, *values) then values.flatten
        elsif all?(Hash, *values) then deeply_merge_hashes_and_arrays(*values)
        else values.last
        end
      end

      def self.frozen_and_can_dup?(val)
        val.frozen? && can_dup?(val)
      end

      def self.can_dup?(obj)
        case obj
        when nil, false, true, Symbol, Numeric then false
        else true
        end
      end

      def self.deep_populate(document, elements)
        return unless elements
        if elements.is_a? String
          document.add_text elements
          return
        end
        elements.each do |name, child|
          document.add_attribute name[1..-1], child and next if '_'.eql? name[0]
          document.elements[name] ||= REXML::Element.new name
          deep_populate document.elements[name], child
        end
      end

      def self.pretty_generate(document)
        output = ''
        formatter = REXML::Formatters::Pretty.new 2
        formatter.compact = true
        formatter.write document, output
        output
      end
    end
  end
end
