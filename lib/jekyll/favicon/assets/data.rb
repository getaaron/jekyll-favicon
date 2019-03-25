module Jekyll
  module Favicon
    # Build Webmanifest JSON
    class Data < Asset
      include Complementable

      MAPPINGS = {
        '.json' => %w[.json .webmanifest],
        '.webmanifest' => %w[.json .webmanifest]
      }.freeze

      def initialize(site, attributes)
        super site, attributes
      end

      def generable?
        mappeable?
      end

      def generate(dest_path)
        site_data = site_references :data
        return unless source_data || site_data
        current_data = JSON.parse(source_data || '{}')
        content = Favicon::Utils.merge current_data, site_data
        File.write dest_path, JSON.pretty_generate(content)
      end
    end
  end
end
