require 'yaml'

module Jekyll
  # Module for custom configurations and defaults
  module Favicon
    GEM_ROOT = Pathname.new File.dirname(File.dirname(__dir__))
    CONFIG_PATH = GEM_ROOT.join 'lib', 'jekyll', 'favicon', 'config'

    def self.build(site)
      @config = nil
      @defaults = nil
      @assets = nil
      consolidate_config site
      load_defaults
      build_assets site
    end

    def self.config
      @config
    end

    def self.defaults
      @defaults
    end

    def self.assets
      @assets
    end

    def self.sources
      assets.reduce(Set[]) { |accum, asset| accum.add asset.source }
    end

    def self.references
      assets.reduce({}) { |accum, asset| deep_merge accum, asset.references }
    end

    def self.tags
      assets.reduce([]) { |tags, asset| tags + asset.tags }
    end

    def self.deep_merge(target, overwrite = {})
      deep_merge!(target.dup, overwrite)
    end

    def self.deep_merge!(target, overwrite)
      target.merge! overwrite do |_key, old_val, new_val|
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

    def self.which_value?(*values)
      if values.last.nil? then values.first
      elsif values.all? { |value| value.is_a? Array } then values.flatten
      elsif values.all? { |value| value.is_a? Hash } then deep_merge(*values)
      else values.last
      end
    end

    def self.duplicable?(obj)
      case obj
      when nil, false, true, Symbol, Numeric then false
      else true
      end
    end

    def self.consolidate_config(site)
      base = YAML.load_file(CONFIG_PATH.join('base.yml'))['favicon']
      @config = deep_merge base, (site.config['favicon'] || {})
    end
    private_class_method :consolidate_config

    def self.load_defaults
      @defaults = %w[processing tags].reduce({}) do |defaults, type|
        defaults_path = CONFIG_PATH.join 'defaults', "#{type}.yml"
        defaults.merge YAML.load_file(defaults_path)['favicon']
      end
    end
    private_class_method :load_defaults

    def self.build_assets(site)
      @assets = config['assets'].collect do |name, customs|
        next if customs == 'skip'
        generate config['source'], site, site.source, config['path'], name,
                 (customs || {})
      end.compact
      @assets.each do |resource|
        resource.generate if resource.is_a? SourcedPage
      end
    end
    private_class_method :build_assets

    def self.generate(source, site, base, dir, name, customs)
      generable = case File.extname name
                  when *Data::MAPPINGS.values.flatten then Data
                  when *Image::MAPPINGS.values.flatten then Image
                  when *Markup::MAPPINGS.values.flatten then Markup
                  end
      generable.new source, site, base, dir, name, customs
    end
    private_class_method :generate
  end
end
