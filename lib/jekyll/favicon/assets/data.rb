module Jekyll
  module Favicon
    # Build Webmanifest JSON
    class Data < SourcedPage
      MAPPINGS = {
        '.json' => %w[.json .webmanifest],
        '.webmanifest' => %w[.json .webmanifest]
      }.freeze

      def initialize(source, site, base, dir, name, custom = {})
        super source, site, base, dir, name, custom
      end

      def generate
        input = JSON.parse @content
        references = Favicon.references[:webmanifest] || {}
        @content = JSON.pretty_generate Favicon.deep_merge input, references
      end

      private

      def load_source
        @content = File.file?(@source) ? File.read(@source) : '{}'
      end
    end
  end
end
