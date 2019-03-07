module Jekyll
  module Favicon
    # Extended generator that creates all the stastic icons and metadata files
    class Generator < Jekyll::Generator
      priority :high

      def generate(site)
        @site = site
        if File.file? File.join @site.source, Favicon.source
          generate_resources
        else
          Jekyll.logger.warn 'Jekyll::Favicon: Missing '\
                             "#{Favicon.source}, not generating "\
                             'favicons.'
        end
      end

      private

      def generate_resources
        Favicon.resources(@site).each do |resource|
          next if resource.unprocessable?
          case resource.extname
          when '.svg', '.png', '.ico'
            @site.static_files.push Icon.new @site, resource
          when '.xml', '.webmanifest', '.json'
            @site.pages.push build_page resource
          end
        end
      end

      def build_page(resource)
        path = resource.path
        basename = resource.basename
        page = Metadata.new @site, @site.source, path, basename
        page.data = { 'layout' => nil }
        page.content = resource.process resource.input, nil
        page
      end
    end
  end
end
