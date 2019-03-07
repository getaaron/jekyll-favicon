module Jekyll
  module Favicon
    # Extended static file that generates multpiple favicons
    class Icon < Jekyll::StaticFile
      attr_accessor :resource

      def initialize(site, resource)
        source = resource.source
        super site, site.source, File.dirname(source), File.basename(source)
        @resource = resource
        @data = { 'name' => @basename, 'layout' => nil }
      end

      def destination(dest)
        basename = @resource.basename
        @site.in_dest_dir(*[dest, destination_rel_dir, basename].compact)
      end

      def destination_rel_dir
        @resource.dirname
      end

      private

      def copy_file(dest_path)
        @resource.process path, dest_path
        File.utime(self.class.mtimes[path], self.class.mtimes[path], dest_path)
      end
    end
  end
end
