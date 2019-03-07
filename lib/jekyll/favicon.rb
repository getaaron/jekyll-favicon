require 'yaml'

module Jekyll
  # Module for custom configurations and defaults
  module Favicon
    GEM_ROOT = Pathname.new(File.dirname(File.dirname(__dir__)))
    PROJECT_LIB = GEM_ROOT.join 'lib'
    PROJECT_ROOT = PROJECT_LIB.join 'jekyll', 'favicon'
    CONFIG_PATH = PROJECT_ROOT.join 'config'

    CONFIG = YAML.load_file(CONFIG_PATH.join('base.yml'))['favicon']
    PROCESSING_CONFIG = YAML.load_file CONFIG_PATH.join 'processing.yml'
    DEFAULTS = PROCESSING_CONFIG['favicon']['defaults']
    TAGS_CONFIG = YAML.load_file CONFIG_PATH.join 'tags.yml'
    DEFAULTS.merge! TAGS_CONFIG['favicon']['defaults']
    CONFIG['defaults'] = DEFAULTS

    # rubocop:disable  Style/ClassVars
    def self.merge(overrides)
      @@config = Jekyll::Utils.deep_merge_hashes CONFIG, (overrides || {})
    end

    def self.config
      @@config ||= CONFIG
    end
    # rubocop:enable  Style/ClassVars

    def self.defaults
      config['defaults']
    end

    def self.source
      config['source']
    end

    def self.path
      config['path']
    end

    def self.sources
      sources = config['resources'].collect do |_, custom|
        custom['source'] if custom.is_a?(Hash) && custom.key?('source')
      end
      sources << source
      sources.compact
    end

    def self.resource(site, basename)
      Favicon.resources(site).each do |resource|
        return resource if resource.basename == basename
      end
    end

    def self.resources(site)
      config['resources'].collect do |basename, customs|
        next if customs == 'skip'
        Resource.new site, source, path, basename, customs
      end.compact
    end

    def self.tags(site)
      Favicon.resources(site).collect(&:tags).flatten.compact
    end

    def self.references(site)
      references = {}
      Favicon.resources(site).each do |resource|
        if resource.references && !resource.references.empty?
          references = deep_merge_hashes_and_arrays references,
                                                    resource.references
        end
      end
      references
    end

    def self.deep_merge_hashes_and_arrays(target, overwrite = {})
      deep_merge_hashes_and_arrays!(target.dup, overwrite)
    end

    def self.deep_merge_hashes_and_arrays!(target, overwrite)
      target.merge!(overwrite) do |_key, old_val, new_val|
        which_value? old_val, new_val
      end
      if target.is_a?(Hash) && overwrite.is_a?(Hash) && target.default_proc.nil?
        target.default_proc = overwrite.default_proc
      end
      target.each do |key, val|
        target[key] = val.dup if val.frozen? && duplicable?(val)
      end
      target
    end

    def self.which_value?(old_val, new_val)
      if new_val.nil?
        old_val
      elsif old_val.is_a?(Array) && new_val.is_a?(Array)
        old_val + new_val
      elsif old_val.is_a?(Hash) && new_val.is_a?(Hash)
        deep_merge_hashes_and_arrays(old_val, new_val)
      else
        new_val
      end
    end

    def self.duplicable?(obj)
      case obj
      when nil, false, true, Symbol, Numeric
        false
      else
        true
      end
    end

    def self.input?(pathname)
      !pathname.nil? && !pathname.empty? && (Image.input?(pathname) ||
      Browserconfig.output?(pathname) || Webmanifest.output?(pathname))
    end

    def self.output?(pathname)
      !pathname.nil? && !pathname.empty? && (Image.output?(pathname) ||
      Browserconfig.output?(pathname) || Webmanifest.output?(pathname))
    end
  end
end
