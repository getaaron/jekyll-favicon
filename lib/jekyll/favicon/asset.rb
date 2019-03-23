require 'jekyll/static_file'

module Jekyll
  module Favicon
    # Extended static file that generates multpiple favicons
    class Asset < Jekyll::StaticFile
      include Sourceable
      include Mappeable
      include Referenceable
      include Taggable

      def initialize(site, attributes)
        super site, site.source, attributes['dir'], attributes['name']
        sourceabilize attributes['source']
        referencialize attributes['webmanifest'], attributes['browserconfig']
        taggabilize attributes['link'], attributes['meta']
      end
    end
  end
end
