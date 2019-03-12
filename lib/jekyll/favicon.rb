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
