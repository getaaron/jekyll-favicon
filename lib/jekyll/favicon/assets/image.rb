module Jekyll
  module Favicon
    # Image abstraction for icons
    class Image < StaticFile
      MAPPINGS = {
        '.png' => %w[.ico .png],
        '.svg' => %w[.ico .png .svg]
      }.freeze

      attr_accessor :sizes

      def initialize(source, site, base, dir, name, custom = {})
        @sizes = []
        super source, site, base, dir, name, custom
      end

      def generate(dest_path)
        convert path, dest_path, @processing
      end

      private

      def convert(input, output, options = {})
        case File.extname output
        when '.svg' then FileUtils.cp input, output
        when '.ico', '.png'
          MiniMagick::Tool::Convert.new do |convert|
            convert << input
            options_for convert, options if options
            convert << output
          end
        else raise ArgumentError
        end
      end

      def options_for(convert, options)
        convert.flatten
        basic_options convert, options
        resize_options convert, options
        odd_options convert, options
      end

      def basic_options(convert, options)
        convert.background options['background'] if options['background']
        if options['define']
          options['define'].each do |option, key_value|
            key, value = key_value.first
            convert.define "#{option}:#{key}=#{value}"
          end
        end
        convert.density options['density'] if options['density']
        convert.alpha options['alpha'] if options['alpha']
      end

      def resize_options(convert, options)
        convert.resize options['resize'] if options['resize']
      end

      def odd_options(convert, options)
        return unless options['odd']
        convert.gravity options['gravity'] if options['gravity']
        convert.extent options['resize'] if options['resize']
      end
    end
  end
end
