module Jekyll
  module Favicon
    # Extended static file that generates multpiple favicons
    class StaticFile < Jekyll::StaticFile
      include Favicon::Sourceable
      include Favicon::Referenceable

      def initialize(source, site, base, dir, name, custom)
        super site, base, dir, name
        @data = { 'name' => @name, 'layout' => nil }
        custom = {} if custom.nil?
        sourceabilize source, custom['source'], custom['path']
        referencialize custom['references']
      end
    end
  end
end
