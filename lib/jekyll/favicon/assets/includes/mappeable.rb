module Jekyll
  module Favicon
    # Add mappeable? to page or static file
    module Mappeable
      MAPPINGS = {}.freeze

      def mappeable?
        self.class::MAPPINGS[source_extname].include?(extname)
      end
    end
  end
end
