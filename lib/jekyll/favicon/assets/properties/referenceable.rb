module Jekyll
  module Favicon
    module Assets
      module Properties
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
            webmanifest_references = references['webmanifest']
            @references[:webmanifest] = parse_icons webmanifest_references
            browserconfig_references = references['browserconfig']
            @references[:browserconfig] = parse_tiles browserconfig_references
          end

          def parse_icons(references)
            return if references.nil? || !references.key?('icons')
            {
              'icons' => [{
                'src' => File.join(*['', @dir, @name].compact),
                'type' => extname[1..-1],
                'sizes' => @sizes.join(' ')
              }]
            }
          end

          def parse_tiles(references)
            return unless references && references['msapplication']
            if (tiles = references['msapplication']['tile'])
              tiles.each do |name, _|
                next unless tiles[name]['_src']
                tiles[name]['_src'] = File.join(*['', @dir, @name].compact)
              end
            end
            { 'browserconfig' => references }
          end
        end
      end
    end
  end
end
