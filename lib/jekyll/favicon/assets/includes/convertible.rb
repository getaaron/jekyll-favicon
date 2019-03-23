require 'mini_magick'

module Jekyll
  module Favicon
    # Add convert images
    module Convertible
      DEFAULTS = YAML.load_file File.join(__dir__, 'defaults', 'convert.yml')

      def self.included(_mod)
        attr_accessor :sizes, :raw_convert, :convert_global_options
      end

      def convertialize(sizes:, name:, background:, raw_convert:)
        @sizes = [sizes || extract_sizes(name)].compact.flatten
        @convert_global_options = {}
        @convert_global_options['background'] = background if background
        @raw_convert = raw_convert || {}
      end

      def convertible?
        @sizes && !@sizes.empty? || '.svg'.eql?(extname)
      end

      def extract_sizes(name)
        name[/.*-(\d+x\d+).[a-zA-Z]+/, 1] if name.respond_to? :match
      end

      def convert_options
        convert_input_options.merge(convert_output_options)
                             .merge(convert_global_options)
                             .merge(@raw_convert)
                             .merge(convert_extra_options)
                             .select { |_, value| value }
      end

      def convert_extra_options
        return {} if @sizes.empty? || extname.eql?('.ico')
        { 'resize' => @sizes.join(' ') }
      end

      def convert_input_options
        DEFAULTS.fetch('input', {})
                .fetch(source_extname, {})
                .select { |_, value| value }
      end

      def convert_output_options
        DEFAULTS.fetch('output', {})
                .fetch(extname, {})
                .select { |_, value| value }
      end

      def convert(input, output, options = {})
        case File.extname output
        when '.svg' then FileUtils.cp input, output
        when '.ico', '.png' then copy input, output, options
        end
      end

      def copy(input, output, options)
        MiniMagick::Tool::Convert.new do |convert|
          properties_from(options) do |property, value|
            convert.send property, value if value
          end
          convert << input
          convert << output
        end
      end

      def properties_from(options, &block)
        basic options, &block
        resize options, &block
      end

      def basic(options, &block)
        yield :background, options['background']
        define options['define'], &block
        yield :density, options['density']
        yield :alpha, options['alpha']
      end

      def define(define_option)
        return unless define_option
        define_option.each do |option, key_value|
          key, value = key_value.first
          if value == 'auto'
            value = @sizes.collect { |size| size.split('x').first }.join(',')
          end
          yield :define, "#{option}:#{key}=#{value}"
        end
      end

      def resize(options)
        return unless options['resize']
        weight, height = options['resize'].split 'x'
        yield :resize, options['resize']
        return if weight == height
        yield :gravity, options['gravity']
        yield :extent, options['resize']
      end
    end
  end
end
