module Jekyll
  module Favicon
    # Image abstraction for icons
    class Image < Asset
      include Convertible

      MAPPINGS = {
        '.png' => %w[.ico .png],
        '.svg' => %w[.ico .png .svg]
      }.freeze

      def initialize(site, attributes)
        super site, attributes
        convertialize sizes: attributes['sizes'],
                      name: attributes['name'],
                      background: attributes['background'],
                      raw_convert: attributes['convert']
      end

      def generable?
        sourceable? && mappeable? && convertible?
      end

      def generate(dest_path)
        convert path, dest_path, convert_options
      end
    end
  end
end
