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
    it 'responds using send' do
      Jekyll::Favicon.must_respond_to :send, :create_assets
    end

    describe 'maps a hash to a SourcedStaticFile collection' do
      it 'create an empty collection if an empty hash is provided' do
        assets = Jekyll::Favicon.send :create_assets, {}, @source, @site, @dir
        assets.must_be_kind_of Array
        assets.must_be_empty
      end

      it "create assets if raw_asset's values are hashes or nil" do
        raw_assets = { 'valid.png' => {}, 'valid.ico' => nil }
        assets = Jekyll::Favicon.send :create_assets, raw_assets, @source,
                                      @site, @dir
        assets.size.must_equal raw_assets.size
        assets.each do |asset|
          asset.must_be_kind_of Jekyll::Favicon::Asset
        end
      end

      it 'skip a raw_asset if its value is skip string' do
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
  end

  describe '.create_asset' do
    it 'responds using send' do
      Jekyll::Favicon.must_respond_to :send, :create_asset
    end

    describe 'when creating an asset with empty site' do
      it 'creates an Jekyll::Favicon::Image instance if name has a valid ' \
        'image extension' do
        %w[.png .ico .svg].each do |extname|
          asset = Jekyll::Favicon.send :create_asset, @source, @site, @base,
                                       @dir, @name + extname, @custom
          asset.must_be_kind_of Jekyll::Favicon::Assets::Image
        end
      end

      it 'create a Jekyll::Favicon::Data instance if name is a json file' do
        %w[.json .webmanifest].each do |extname|
          asset = Jekyll::Favicon.send :create_asset, @source, @site, @base,
                                       @dir, @name + extname, @custom
          asset.must_be_kind_of Jekyll::Favicon::Assets::Data
        end
      end

      it 'create a Jekyll::Favicon::Markup instance if name is an xml file' do
        asset = Jekyll::Favicon.send :create_asset, @source, @site, @base,
                                     @dir, @name + '.xml', @custom
        asset.must_be_kind_of Jekyll::Favicon::Assets::Markup
      end
    end
  end

  describe '.config' do
    it 'responds' do
      Jekyll::Favicon.must_respond_to :config
      config = Jekyll::Favicon.config {}
      config.must_be_kind_of Hash
      config.wont_be_empty
    end
  end

  describe '.defaults' do
    it 'responds' do
      Jekyll::Favicon.must_respond_to :defaults
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
    it 'responds' do
      Jekyll::Favicon.must_respond_to :assets
      assets = Jekyll::Favicon.assets @site
      assets.must_be_kind_of Array
      assets.wont_be_empty
      assets.each do |asset|
        asset.must_be_kind_of Jekyll::Favicon::Asset
      end
    end
  end

  describe '.sources' do
    it 'responds to' do
      Jekyll::Favicon.must_respond_to :sources
      sources = Jekyll::Favicon.sources @site
      sources.must_be_kind_of Set
      sources.wont_be_empty
    end
  end

  describe '.references' do
    it 'responds to' do
      Jekyll::Favicon.must_respond_to :references
      references = Jekyll::Favicon.references @site
      references.must_be_kind_of Hash
      references.must_be_empty
    end
  end
end
