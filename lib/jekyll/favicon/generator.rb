module Jekyll
  module Favicon
    # Extended generator that creates all the icons and data files
    class Generator < Jekyll::Generator
      priority :high

      def generate(site)
        @site = site
        Favicon.assets(@site).each do |asset|
          @site.static_files.push asset if asset.generable?
        end
      end
    end
  end
end
