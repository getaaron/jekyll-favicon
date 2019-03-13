module Jekyll
  module Favicon
    module Assets
      module Properties
        # Add convert images
        module Convertible
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
            processing = {}
            processing_defaults = Jekyll::Favicon.defaults['processing']
            input_processing = update_input_processing processing_defaults
            processing = Favicon::Utils.merge processing, input_processing
            output_processing = update_output_processing processing_defaults
            processing = Favicon::Utils.merge processing, output_processing
            return processing unless custom
            processing
          end

          def update_input_processing(configs)
            return {} unless configs['input'].key? source_extname
            configs['input'][source_extname]
          end

          def update_output_processing(configs)
            return {} unless configs['output'].key? extname
            configs['output'][extname]
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
