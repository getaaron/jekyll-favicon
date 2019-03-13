module Jekyll
  # build and provide config, assets and related
  module Favicon
    GEM_ROOT = Pathname.new File.dirname File.dirname __dir__
    CONFIG_PATH = GEM_ROOT.join 'lib', 'jekyll', 'favicon', 'config'
    BASE = YAML.load_file CONFIG_PATH.join 'base.yml'
    TAGS = YAML.load_file CONFIG_PATH.join 'defaults', 'tags.yml'
    PROCESSING = YAML.load_file CONFIG_PATH.join 'defaults', 'processing.yml'

    def self.config(masks = {})
      Utils.merge BASE['favicon'], masks, override: masks['override']
    end

    def self.defaults
      Utils.merge TAGS['favicon'], PROCESSING['favicon']
    end

    def self.assets(site)
      base = config(site.config['favicon'] || {})
      create_assets base['assets'], base['source'], site, base['path']
    end

    def self.sources(site)
      assets(site).reduce(Set[]) { |sources, asset| sources.add asset.source }
    end

    def self.references(site)
      assets(site).reduce({}) do |references, asset|
        if asset.generable?
          Utils.merge references, asset.references
        else references
        end
      end
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
              when *Assets::Data::MAPPINGS.values.flatten then Assets::Data
              when *Assets::Image::MAPPINGS.values.flatten then Assets::Image
              when *Assets::Markup::MAPPINGS.values.flatten then Assets::Markup
              end
      asset.new source, site, base, dir, name, customs
    end
    private_class_method :create_asset
  end
end
