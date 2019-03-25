module Jekyll
  module Favicon
    # Add references to a static_file
    module Referenceable
      def self.included(_mod)
        attr_accessor :raw_data, :raw_markup
      end

      def referencialize(raw_data, raw_markup)
        @raw_data = Utils.merge({}, raw_data)
        @raw_markup = Utils.merge({ 'browserconfig' =>
                                      { 'msapplication' => {} } },
                                  'browserconfig' => raw_markup)
      end

      def references(type)
        send type
      end

      private

      def data
        @raw_data['icons'] ? { 'icons' => [to_icon] } : {}
      end

      def to_icon
        icon = joint_sizes ? { sizes: joint_sizes } : {}
        icon.merge src: relative_url, type: mime_type, purpose: 'any'
      end

      def markup
        config = Marshal.load Marshal.dump @raw_markup
        raw_tiles = config['browserconfig']['msapplication'].fetch 'tile', {}
        raw_tiles.each do |name, _|
          tile_src = raw_tiles[name]['_src']
          tile_src_matches_asset_name = tile_src && @name.eql?(tile_src)
          next unless tile_src_matches_asset_name
          raw_tiles[name]['_src'] = relative_url
        end
        config
      end
    end
  end
end
