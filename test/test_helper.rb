$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'jekyll-favicon'
require 'minitest/autorun'
require 'minitest/hooks/default'

Jekyll.logger.log_level = :error

def fixture(*subdirs)
  File.expand_path File.join('..', 'test', 'fixtures', *subdirs), __dir__
end

module Jekyll
  module Favicon
    class StaticFile < Jekyll::StaticFile
      def inspect
        "<StaticFile name='#{@name}'>"
      end
    end
  end
end
