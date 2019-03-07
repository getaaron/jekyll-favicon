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
        content = []
        content << "<!-- Begin Jekyll Favicon tag v#{Favicon::VERSION} -->"
        content << Favicon.tags(site)
        content << '<!-- End Jekyll Favicon tag -->'
        content.flatten.join "\n"
      end
    end
  end
end

Liquid::Template.register_tag('favicon', Jekyll::Favicon::Tag)
