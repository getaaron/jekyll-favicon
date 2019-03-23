module Jekyll
  module Favicon
    # Build Webmanifest JSON
    class Data < Asset
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
        current_data = JSON.parse File.read path if File.file? path
        new_data = collect_references :webmanifest
        return unless current_data || new_data
        content = Favicon::Utils.merge (current_data || {}), new_data
        File.write dest_path, JSON.pretty_generate(content)
      end
    end
  end
end
