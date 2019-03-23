require 'liquid'

module Jekyll
  module Favicon
    # `favicon` tag for favicon include on templates
    class Tag < Liquid::Tag
      def render(context)
        site = context.registers[:site]
        site.static_files.collect do |static_file|
          static_file.tags if static_file.is_a? Favicon::Asset
        end.flatten.compact.join "\n"
      end
    end
  end
end

Liquid::Template.register_tag 'favicon', Jekyll::Favicon::Tag
