module Jekyll
  module Favicon
    # Build browserconfig XML
    class Markup < Asset
      include Complementable

      MAPPINGS = { '.xml' => %w[.xml] }.freeze

      def initialize(site, attributes)
        super site, attributes
      end

      def generable?
        mappeable?
      end

      def generate(dest_path)
        site_markup = site_references :markup
        return unless source_data || site_markup
        document = REXML::Document.new source_data
        Favicon::Utils.deep_populate document, site_markup
        File.write dest_path, Favicon::Utils.pretty_generate(document)
      end

      private

      def ensure_tag?(_tag_name)
        false
      end
    end
  end
end
