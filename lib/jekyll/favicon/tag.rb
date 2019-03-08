module Jekyll
  module Favicon
    # New `favicon` tag for favicon include on templates
    class Tag < Liquid::Tag
      def initialize(tag_name, text, tokens)
        super
        @text = text
      end

      def render(context)
        site = context.registers[:site]
        tags = Favicon.tags site
        tags = wrap tags
        @content = tags.join "\n"
      end

      private

      def wrap(tags)
        tags.unshift "<!-- Begin Jekyll Favicon Tag v#{Favicon::VERSION} -->"
        tags.push '<!-- End Jekyll Favicon Tag -->'
      end
    end
  end
end

Liquid::Template.register_tag 'favicon', Jekyll::Favicon::Tag
