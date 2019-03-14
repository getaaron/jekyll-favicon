require 'test_helper'

describe Jekyll::Favicon do
  before :all do
    @site = Jekyll::Site.new Jekyll.configuration
    @source = 'valid-source.svg'
    @base = ''
    @dir = ''
    @name = 'invalid-source.txt'
    @custom = {}
  end

  describe '.create_assets' do
    it 'is a private method' do
      Jekyll::Favicon.wont_respond_to :create_assets
      Jekyll::Favicon.must_respond_to :send, :create_assets
    end

    it 'provides a empty collection if an empty hash is provided' do
      assets = Jekyll::Favicon.send :create_assets, {}, @source, @site, @dir
      assets.must_be_kind_of Array
      assets.must_be_empty
    end

    it "provides an Jekyll::Favicon::Asset collection if raw_asset's values " \
       'are hashes or nil' do
      raw_assets = { 'valid.png' => {}, 'valid.ico' => nil }
      assets = Jekyll::Favicon.send :create_assets, raw_assets, @source,
                                    @site, @dir
      assets.size.must_equal raw_assets.size
      assets.each do |asset|
        asset.must_be_kind_of Jekyll::Favicon::Asset
      end
    end

    it 'skip a raw_asset if its value is the string `skip`' do
      raw_assets = { 'valid.png' => 'skip' }
      assets = Jekyll::Favicon.send :create_assets, raw_assets, @source,
                                    @site, @dir
      assets.must_be_empty
      raw_assets = { 'skip-this.png' => 'skip', 'valid.svg' => {} }
      assets = Jekyll::Favicon.send :create_assets, raw_assets, @source,
                                    @site, @dir
      assets.size.must_equal 1
      assets.first.name.must_equal 'valid.svg'
    end
  end

  describe '.create_asset' do
    it 'is a private method' do
      Jekyll::Favicon.wont_respond_to :create_asset
      Jekyll::Favicon.must_respond_to :send, :create_asset
    end

    it 'creates a Jekyll::Favicon::Image asset instance if the name has a ' \
       'valid image extension' do
      %w[.png .ico .svg].each do |extname|
        asset = Jekyll::Favicon.send :create_asset, @source, @site, @base,
                                     @dir, @name + extname, @custom
        asset.must_be_kind_of Jekyll::Favicon::Assets::Image
      end
    end

    it 'creates a Jekyll::Favicon::Data asset instance if the name has a ' \
       'valid Webmanifest extension' do
      %w[.json .webmanifest].each do |extname|
        asset = Jekyll::Favicon.send :create_asset, @source, @site, @base,
                                     @dir, @name + extname, @custom
        asset.must_be_kind_of Jekyll::Favicon::Assets::Data
      end
    end

    it 'creates a Jekyll::Favicon::Markup asset instance if the name has a ' \
       'valid Browserconfig extension' do
      asset = Jekyll::Favicon.send :create_asset, @source, @site, @base,
                                   @dir, @name + '.xml', @custom
      asset.must_be_kind_of Jekyll::Favicon::Assets::Markup
    end
  end

  describe '.config' do
    it 'is a public method' do
      Jekyll::Favicon.must_respond_to :config
    end

    it 'deeply merges base favicon config with provided Hash' do
      config = Jekyll::Favicon.config {}
      config.must_be_kind_of Hash
      config.wont_be_empty
    end
  end

  describe '.defaults' do
    it 'is a public method' do
      Jekyll::Favicon.must_respond_to :defaults
    end

    it 'provides a Hash containing favicon defaults' do
      defaults = Jekyll::Favicon.defaults
      defaults.must_be_kind_of Hash
      defaults.wont_be_empty
      defaults.keys.must_include 'processing'
      processing = defaults['processing']
      processing.must_be_kind_of Hash
      processing.wont_be_empty
    end
  end

  describe '.assets' do
    it 'is a public method' do
      Jekyll::Favicon.must_respond_to :assets
    end

    it "maps config's assets to a collection of Jekyll::Favicon::Asset" do
      assets = Jekyll::Favicon.assets @site
      assets.must_be_kind_of Array
      assets.wont_be_empty
      assets.each do |asset|
        asset.must_be_kind_of Jekyll::Favicon::Asset
      end
    end
  end

  describe '.sources' do
    it 'is a public method' do
      Jekyll::Favicon.must_respond_to :sources
    end

    it "collects the different source's names through all assets" do
      sources = Jekyll::Favicon.sources @site
      sources.must_be_kind_of Set
      sources.wont_be_empty
    end
  end

  describe '.references' do
    it 'is a public method' do
      Jekyll::Favicon.must_respond_to :references
    end

    it 'collects and unifies all the references through all assets' do
      references = Jekyll::Favicon.references @site
      references.must_be_kind_of Hash
      references.must_be_empty
    end
  end
end
