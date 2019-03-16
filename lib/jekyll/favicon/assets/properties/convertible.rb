module Jekyll
  module Favicon
    module Assets
      module Properties
        # Add convert images
        module Convertible
          DEFAULTS = Jekyll::Favicon.defaults['processing']

          def self.included(_mod)
            attr_accessor :sizes, :processing
          end

          def convertible?
            @sizes && !@sizes.empty? || '.svg'.eql?(extname)
          end

          def extract_sizes(name)
            name[/.*-(\d+x\d+).[a-zA-Z]+/, 1] if name.respond_to? :match
          end

          def parse_processing_from(custom)
            parsed = DEFAULTS.fetch('input', {}).fetch(source_extname, {})
                             .merge DEFAULTS.fetch('output', {})
                                            .fetch(extname, {})
            return parsed unless custom
            return parsed unless @sizes || !extname.eql?('.ico')
            parsed.update 'resize' => @sizes.join
          end

          def convert(input, output, options = {})
            case File.extname output
            when '.svg' then FileUtils.cp input, output
            when '.ico', '.png' then copy input, output, options
            end
          end

          def copy(input, output, options)
            MiniMagick::Tool::Convert.new do |convert|
              convert << input
              properties_from(options) do |property, value|
                convert.send property, value if value
              end
              convert << output
            end
          end

          def properties_from(options, &block)
            basic options, &block
            resize options, &block
            odd options, &block
          end

          def basic(options)
            yield :background, options['background']
            if options['define']
              options['define'].each do |option, key_value|
                key, value = key_value.first
                yield :define, "#{option}:#{key}=#{value}"
              end
            end
            yield :density, options['density']
            yield :alpha, options['alpha']
          end

          def resize(options)
            yield :resize, options['resize']
          end

          def odd(options)
            return unless options['odd']
            yield :gravity, options['gravity']
            yield :extent, options['resize']
          end
        end
      end
    end
  end
end
