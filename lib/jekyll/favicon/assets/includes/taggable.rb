require 'rexml/document'

module Jekyll
  module Favicon
    # Common functionality for HMTL tags abstraction
    module Taggable
      DEFAULTS = YAML.load_file File.join(__dir__, 'defaults', 'tags.yml')

      def self.included(_mod)
        attr_accessor :raw_link, :raw_meta
      end

      def taggabilize(link, meta)
        @raw_link = link
        @raw_meta = meta
      end

      def taggable?
        true
      end

      def tags
        grouped_tags.collect do |tag_name, raw_tags|
          next if 'skip'.eql? raw_tags
          transformed = transform_raw_tags tag_name, raw_tags
          key_attribute = DEFAULTS['key'][tag_name]
          create_tags tag_name, key_attribute, transformed
        end.compact.flatten
      end

      private

      def grouped_tags
        output = {}
        output['link'] = @raw_link if @raw_link
        output['meta'] = @raw_meta if @raw_meta
        output
      end

      def transform_raw_tags(tag_name, raw_tags)
        defaults = DEFAULTS.fetch(tag_name, {})
                           .fetch(extname, DEFAULTS[tag_name])
        Config.transform raw_tags, base_values: defaults,
                                   ensure_one: ensure_tag?(tag_name)
      end

      def create_tags(tag_name, key_attribute, customs)
        customs.collect do |raw_tag|
          next if skip? raw_tag.delete 'skip'
          create_tag tag_name, patch_raw_tag(key_attribute, raw_tag)
        end.compact
      end

      def create_tag(name, attributes)
        element = REXML::Element.new name
        element.add_attributes attributes
        element
      end

      def patch_raw_tag(key, raw_tag)
        raw_tag.delete 'sizes' unless raw_tag['sizes']
        raw_tag['sizes'] = joint_sizes if resize? raw_tag['sizes']
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

      def relative_path
        File.dirname relative_url
      end

      def relative_url
        File.join(*[(@site.baseurl || ''), @dir, @name].compact)
      end

      def ensure_tag?(tag_name)
        ['link'].include?(tag_name)
      end
    end
  end
end
