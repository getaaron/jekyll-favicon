module Jekyll
  module Favicon
    # Extended Page that generate files from ERB templates
    class SourcedPage < Jekyll::Page
      include Favicon::Sourceable
      include Favicon::Referenceable

      def initialize(source, site, base, dir, name, custom)
        sourceabilize source, dir, custom['source'], custom['path']
        referencialize custom['references']
        super site, base, @dir, name
      end

      # rubocop:disable Naming/MemoizedInstanceVariableName
      def read_yaml(*)
        load_source
        @data ||= {}
      end
      # rubocop:enable Naming/MemoizedInstanceVariableName
    end
  end
end
