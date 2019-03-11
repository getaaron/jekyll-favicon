module Jekyll
  module Favicon
    # Build Webmanifest JSON
    class Data < StaticFile
      MAPPINGS = {
        '.json' => %w[.json .webmanifest],
        '.webmanifest' => %w[.json .webmanifest]
      }.freeze

      def initialize(source, site, base, dir, name, custom = {})
        super source, site, base, dir, name, custom
      end

      def generate(dest_path)
        input = JSON.parse File.file?(@source) ? File.read(@source) : '{}'
        references = Favicon.references[:webmanifest] || {}
        content = JSON.pretty_generate Favicon.deep_merge input, references
        File.write dest_path, content
      end
    end
  end
end
