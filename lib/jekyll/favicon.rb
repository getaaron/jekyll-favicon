module Jekyll
  # build and provide config, assets and related
  module Favicon
    GEM_ROOT = Pathname.new File.dirname File.dirname __dir__
    CONFIG_PATH = GEM_ROOT.join 'lib', 'jekyll', 'favicon', 'config'
    BASE = YAML.load_file CONFIG_PATH.join 'base.yml'
    TAGS = YAML.load_file CONFIG_PATH.join 'defaults', 'tags.yml'
    PROCESSING = YAML.load_file CONFIG_PATH.join 'defaults', 'processing.yml'

    def self.build(site, custom)
      @config = merge BASE['favicon'], custom, override: custom['override']
      @defaults = merge TAGS['favicon'], PROCESSING['favicon']
      @assets = create_assets @config['assets'], @config['source'], site,
                              @config['path']
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
      @assets.reduce(Set[]) { |accum, asset| accum.add asset.source }
    end

    def self.references
      @assets.reduce({}) { |accum, asset| merge accum, asset.references }
    end

    def self.tags
      @assets.reduce([]) { |tags, asset| tags + asset.tags }
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

    def self.merge(base, custom, override: false)
      return base unless custom
      return base.merge custom if override
      Utils.deeply_merge_hashes_and_arrays base, custom
    end

    def self.create_assets(assets, source, site, dir)
      assets.collect do |name, customs|
        next if customs == 'skip'
        customs ||= {}
        create_asset source, site, site.source, dir, name, customs
      end.compact
    end
    private_class_method :create_assets

    def self.create_asset(source, site, base, dir, name, customs)
      asset = case File.extname name
              when *Data::MAPPINGS.values.flatten then Data
              when *Image::MAPPINGS.values.flatten then Image
              when *Markup::MAPPINGS.values.flatten then Markup
              end
      asset.new source, site, base, dir, name, customs
    end
    private_class_method :create_asset
  end
end
