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

      def path
        File.join(*[@base, source_dir, source_name].compact)
      end

      def modified_time
        @modified_time ||= File.file?(path) ? File.stat(path).mtime : Time.now
      end

      private

      def copy_file(dest_path)
        generate dest_path
      end
    end
  end
end
