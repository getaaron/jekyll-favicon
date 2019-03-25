module Jekyll
  module Favicon
    # Enable asset to find references in site's asset
    module Complementable
      def site_references(type)
        site_assets.reduce({}) do |site_references, asset|
          Utils.merge site_references, asset.references(type)
        end
      end

      def site_assets
        static_files = @site.static_files
        static_files.select { |file| asset?(file) && referenceable?(file) }
      end

      private

      def asset?(file)
        file.is_a? Asset
      end

      def referenceable?(file)
        file.respond_to? :references
      end
    end
  end
end
