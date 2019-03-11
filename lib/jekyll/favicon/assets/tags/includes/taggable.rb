# module Jekyll
#   module Favicon
#     # Common functionality for HMTL tags abstraction
#     class Tag
#       def self.included(mod)
#         attr_accessor :tags
#       end
#
#       def InstanceMethods
#         def taggabilize(site, source, path, basename, overrides = {})
#           @tags = generate_tags_from overrides
#         end
#
#         def generate_tags_from(overrides)
#           [Meta, Link].collect do |klass|
#             klass.build self, overrides, ensure_link?
#           end.flatten.compact
#         end
#
#         private
#
#         def ensure_link?; true; end
#       end
#     end
#   end
# end
