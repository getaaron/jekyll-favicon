# module Jekyll
#   module Favicon
#     # Common functionality for HMTL tags abstraction
#     class Tag
#       attr_accessor :skip
#
#       def self.build(resource, configs = {}, ensure_tag = false)
#         parse_config(configs[key], ensure: ensure_tag).collect do |customs|
#           tag = new resource, customs
#           tag unless tag.skip?
#         end.compact
#       end
#
#       def self.normalized_array_config(configs, options = {})
#         options[:ensure] && configs.empty? ? [{}] : configs
#       end
#
#       def self.normalized_string_config(configs, options = {})
#         options[:ensure] && !'skip'.eql?(configs) ? [{}] : []
#       end
#
#       def self.normalized_nil_config(options = {})
#         options[:ensure] ? [{}] : []
#       end
#
#       def self.parse_config(configs, options = {})
#         case configs
#         when Hash then [configs]
#         when Array then normalized_array_config configs, options
#         when String then normalized_string_config configs, options
#         when NilClass then normalized_nil_config options
#         else []
#         end
#       end
#
#       def self.key
#         to_s.downcase + 's'
#       end
#
#       def to_s
#         tag_name = self.class.to_s.downcase
#         attributes = instance_variables.collect do |variable|
#           next if :@skip.eql? variable
#           attribute = to_html_attribute variable
#           value = instance_variable_get variable
#           next unless value
#           next if value.respond_to?(:empty) && value.empty?
#           "#{attribute}='#{value}'"
#         end.compact
#         "<#{tag_name} #{attributes.join(' ')}>"
#       end
#
#       def to_html_attribute(variable)
#         variable.to_s[1..-1].sub('_', '-')
#       end
#
#       def skip?
#         @skip || false
#       end
#     end
#   end
# end
