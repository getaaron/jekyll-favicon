require 'rexml/document'

module Jekyll
  module Favicon
    # Build browserconfig XML
    class Markup < SourcedStaticFile
      MAPPINGS = { '.xml' => %w[.xml] }.freeze

      def initialize(source, site, base, dir, name, custom = {})
        super source, site, base, dir, name, custom
      end

      def generate(dest_path)
        references = Favicon.references[:browserconfig]
        raw_source = File.read @source if File.file? @source
        document = REXML::Document.new raw_source
        deep_populate document, references
        content = pretty_generate document
        File.write dest_path, content
      end

      private

      def ensure_link?
        false
      end

      def deep_populate(parent, tree)
        if tree.is_a? String
          parent.add_text tree
          return
        end
        tree.each do |name, subtree|
          parent.add_attribute name[1..-1], subtree and next if '_'.eql? name[0]
          parent.elements[name] ||= REXML::Element.new name
          deep_populate parent.elements[name], subtree
        end
      end

      def pretty_generate(document)
        output = ''
        formatter = REXML::Formatters::Pretty.new 2
        formatter.compact = true
        formatter.write document, output
        output
      end
    end
  end
end
