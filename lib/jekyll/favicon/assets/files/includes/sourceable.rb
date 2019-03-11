module Jekyll
  module Favicon
    # Add source reference to page or static file
    module Sourceable
      MAPPINGS = {}.freeze

      def self.included(_mod)
        attr_accessor :source
      end

      def sourceabilize(source, dir, override_source, override_dir)
        @source = override_source || source
        @dir = override_dir || dir || ''
      end

      def sourceable?
        self.class::MAPPINGS[source_extname].include? extname
      end

      def source_extname
        File.extname @source
      end

      def source_dir
        File.dirname @source
      end

      def source_name
        File.basename @source
      end
    end
  end
end
