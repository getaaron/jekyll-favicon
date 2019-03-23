require 'rexml/document'

module Jekyll
  module Favicon
    # Common functionality for HMTL tags abstraction
    module Taggable
      DEFAULTS = YAML.load_file File.join(__dir__, 'defaults', 'tags.yml')

      def self.included(_mod)
        attr_accessor :raw_links, :raw_metas
      end

      def taggabilize(links, metas)
        @raw_links = links
        @raw_metas = metas
      end

      def grouped_tags
        output = {}
        output['links'] = @raw_links if @raw_links
        output['metas'] = @raw_metas if @raw_metas
        output
      end

      def tags
        grouped_tags.collect do |tag_type, raw_tags|
          next if 'skip'.eql? raw_tags
          transformed = transform_raw_tags tag_type, raw_tags
          tag_name = DEFAULTS['name'][tag_type]
          key_attribute = DEFAULTS['key'][tag_type]
          create_tags tag_name, key_attribute, transformed
        end.compact.flatten
      end

      def transform_raw_tags(tag_type, raw_tags)
        defaults = DEFAULTS.fetch(tag_type, {})
                           .fetch(extname, DEFAULTS[tag_type])
        Config.transform raw_tags, base_values: defaults,
                                   ensure_one: ensure_tag?(tag_type)
      end

      def create_tags(tag_name, key_attribute, customs)
        customs.collect do |raw_tag|
          next if skip? raw_tag.delete 'skip'
          create_tag tag_name, patch_raw_tag(key_attribute, raw_tag)
        end.compact
      end

      def patch_raw_tag(key, raw_tag)
        raw_tag.delete 'sizes' unless raw_tag['sizes']
        raw_tag['sizes'] = @sizes.join(' ') if resize? raw_tag['sizes']
        raw_tag[key] = relative_url if rename? raw_tag[key]
        raw_tag
      end

      def rename?(name)
        name.nil? || name.eql?(@name)
      end

      def resize?(sizes)
        'auto'.eql? sizes
      end

      def skip?(skip)
        'skip'.eql?(skip) || ('root'.eql?(skip) && '/'.eql?(relative_path))
      end

      def create_tag(name, attributes)
        element = REXML::Element.new name
        element.add_attributes attributes
        element
      end

      def taggable?
        true
      end

      def relative_path
        File.dirname relative_url
      end

      def relative_url
        File.join(*[(@site.baseurl || ''), @dir, @name].compact)
      end

      private

      def ensure_tag?(tag_name)
        ['links'].include?(tag_name)
      end
    end
  end
end
