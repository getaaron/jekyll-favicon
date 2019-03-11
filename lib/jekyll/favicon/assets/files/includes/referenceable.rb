module Jekyll
  module Favicon
    # add references to page or static_file
    module Referenceable
      def self.included(_mod)
        attr_accessor :references
      end

      def referencialize(references)
        @references = {}
        parse_from references
      end

      private

      def parse_from(references)
        return if references.nil?
        @references[:webmanifest] = parse_icons references['webmanifest']
        @references[:browserconfig] = parse_tiles references['browserconfig']
      end

      def parse_icons(references)
        return {} if references.nil? || !references.key?('icons')
        {
          'icons' => [{
            'src' => url,
            'type' => extname[1..-1],
            'sizes' => @sizes.join(' ')
          }]
        }
      end

      def parse_tiles(references)
        return unless references
        if references['msapplication'] && references['msapplication']['tile']
          references['msapplication']['tile'].each do |key, _|
            if references['msapplication']['tile'][key]['_src']
              references['msapplication']['tile'][key]['_src'] = url
            end
          end
        end
        { 'browserconfig' => references }
      end
    end
  end
end
