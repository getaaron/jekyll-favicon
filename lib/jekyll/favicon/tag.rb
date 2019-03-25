require 'liquid'

module Jekyll
  module Favicon
    # `favicon` tag render site's assets tags
    class Tag < Liquid::Tag
      def render(context)
        site = context.registers[:site]
        static_files = site.static_files
        assets = static_files.select { |file| file.is_a? Favicon::Asset }
        tags = assets.collect(&:tags).flatten
        tags.join "\n"
      end
    end
  end
end

Liquid::Template.register_tag 'favicon', Jekyll::Favicon::Tag
