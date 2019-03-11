module Jekyll
  module Favicon
    # Extended static file that generates multpiple favicons
    class SourcedStaticFile < Jekyll::StaticFile
      include Favicon::Sourceable
      include Favicon::Referenceable

      def initialize(source, site, base, dir, name, custom)
        sourceabilize source, dir, custom['source'], custom['path']
        super site, base, @dir, name
        @data = { 'name' => @name, 'layout' => nil }
        custom = {} if custom.nil?
        referencialize custom['references']
      end

      def path
        File.join(*[@base, source_dir, source_name].compact)
      end

      def type
        :static_files
      end

      private

      def copy_file(dest_path)
        generate dest_path
      end
    end
  end
end
