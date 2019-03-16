module Jekyll
  module Favicon
    module Assets
      module Properties
        # Common functionality for HMTL tags abstraction
        module Taggable
          DEFAULTS = Jekyll::Favicon.defaults['tags']

          def self.included(_mod)
            attr_accessor :tags
          end

          def taggabilize(grouped_customs)
            @tags = grouped_customs.collect do |type, customs|
              create_tags type, customs
            end.flatten
          end

          def create_tags(type, customs)
            defaults = DEFAULTS.fetch(type, {}).fetch(extname, DEFAULTS[type])
            required = { DEFAULTS['keys'][type] => relative_url }
            raw_tags = Utils.normalize customs, defaults: defaults,
                                                overrides: required,
                                                ensure_value: ensure_tag?(type)
            raw_tags.collect { |raw_tag| create_tag type, raw_tag }
          end

          def create_tag(name, attributes)
            element = REXML::Element.new name
            element.add_attributes attributes
            element
          end

          def taggable?
            true
          end

          def relative_url
            File.join(*['', @dir, @name].compact)
          end

          private

          def ensure_tag?(tag_name)
            ['link'].include?(tag_name)
          end
        end
      end
    end
  end
end
