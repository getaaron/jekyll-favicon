module Jekyll
  module Favicon
    # add references to page or static_file
    module Referenceable
      def self.included(_mod)
        attr_accessor :raw_webmanifest, :raw_browserconfig
      end

      def referencialize(raw_webmanifest, raw_browserconfig)
        default_webmanifest = {}
        @raw_webmanifest = Favicon::Utils.merge default_webmanifest,
                                                raw_webmanifest
        default_browserconfig = { 'browserconfig' => { 'msapplication' => {} } }
        user_browserconfig = { 'browserconfig' => raw_browserconfig }
        @raw_browserconfig = Favicon::Utils.merge default_browserconfig,
                                                  user_browserconfig
      end

      def references(type)
        case type
        when :webmanifest then parse_icons
        when :browserconfig then parse_tiles
        end
      end

      def collect_references(type)
        @site.static_files.reduce({}) do |references, asset|
          if asset.is_a?(Asset)
            Utils.merge references, asset.references(type)
          else references
          end
        end
      end

      private

      def parse_icons
        raw_icons = @raw_webmanifest.fetch 'icons', nil
        return {} unless raw_icons
        icon = { 'src' => relative_url, 'type' => extname[1..-1] }
        icon['sizes'] = @sizes.join ' ' if @sizes
        { 'icons' => [icon] }
      end

      def parse_tiles
        browserconfig = Marshal.load Marshal.dump @raw_browserconfig
        tiles = browserconfig.fetch('browserconfig', {})
                             .fetch('msapplication', {})
                             .fetch('tile', {})
        tiles.each do |name, _|
          next unless tiles[name]['_src']
          tiles[name]['_src'] = relative_url if @name.eql? tiles[name]['_src']
        end
        browserconfig
      end
    end
  end
end
