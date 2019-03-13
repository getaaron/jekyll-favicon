module Jekyll
  module Favicon
    module Assets
      # Image abstraction for icons
      class Image < StaticFile
        include Assets::Properties::Convertible

        MAPPINGS = {
          '.png' => %w[.ico .png],
          '.svg' => %w[.ico .png .svg]
        }.freeze

        def initialize(source, site, base, dir, name, custom = {})
          @sizes = [custom['sizes'] || extract_sizes(name)].compact.flatten
          super source, site, base, dir, name, custom
          @processing = parse_processing_from custom['processing']
        end

        def generable?
          sourceable? && mappeable? && convertible?
        end

        def generate(dest_path)
          convert path, dest_path, @processing
        end
      end
    end
  end
end
