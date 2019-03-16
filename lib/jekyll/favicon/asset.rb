module Jekyll
  module Favicon
    # Extended static file that generates multpiple favicons
    class Asset < Jekyll::StaticFile
      include Favicon::Assets::Properties::Sourceable
      include Favicon::Assets::Properties::Mappeable
      include Favicon::Assets::Properties::Referenceable
      include Favicon::Assets::Properties::Taggable

      def initialize(source, site, base, dir, name, custom)
        super site, base, dir, name
        custom ||= {}
        sourceabilize source, custom['source'], custom['path']
        referencialize custom['references']
        taggabilize 'link' => custom['links'], 'meta' => custom['metas']
      end
    end
  end
end
