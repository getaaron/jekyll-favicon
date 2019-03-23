module Jekyll
  module Favicon
    # Build browserconfig XML
    class Markup < Asset
      MAPPINGS = { '.xml' => %w[.xml] }.freeze

      def initialize(site, attributes)
        super site, attributes
      end

      def generable?
        mappeable?
      end

      def generate(dest_path)
        current_markup = File.read path if File.file? path
        new_markup = collect_references :browserconfig
        return unless current_markup || new_markup
        document = REXML::Document.new current_markup
        Favicon::Utils.deep_populate document, new_markup
        File.write dest_path, Favicon::Utils.pretty_generate(document)
      end

      private

      def ensure_tag?(_tag_name)
        false
      end
    end
  end
end
