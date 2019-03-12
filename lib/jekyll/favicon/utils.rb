module Jekyll
  module Favicon
    # provide common functionality methods
    module Utils
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
    end
  end
end
