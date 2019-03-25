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
                      convert_user_options: attributes['convert']
      end

      def generable?
        sourceable? && mappeable? && convertible?
      end

      def generate(dest_path)
        convert path, dest_path, convert_options
      end

      def mime_type
        case extname
        when '.ico' then 'image/x-icon'
        when '.png' then 'image/png'
        when '.svg' then 'image/svg+xml'
        end
      end
    end
  end
end
