require 'test_helper'

describe Jekyll::Favicon do
  let(:site) { Jekyll::Site.new Jekyll.configuration }
  let(:basename) { 'filename.svg' }
  let(:dir) { 'pathname' }
  let(:config) { {} }

  describe '.create_assets' do
    it 'is a private method' do
      Jekyll::Favicon.wont_respond_to :create_assets
      Jekyll::Favicon.must_respond_to :send, :create_assets
    end

    it 'provides a empty collection if an empty hash is provided' do
      assets_configs = {}
      arguments = [assets_configs, basename, site, dir]
      assets = Jekyll::Favicon.send :create_assets, *arguments
      assets.must_be_kind_of Array
      assets.must_be_empty
    end

    it "provides an Jekyll::Favicon::Asset collection if raw_asset's values " \
       'are hashes or nil' do
      assets_configs = {
        'valid-1x1.png' => nil,
        'valid-2x2.png' => '',
        'valid-3x3.png' => 'non-skip-text',
        'valid-4x4.png' => {},
        'valid-5x5.png' => { 'key' => 'value' },
        'valid-6x6.png' => []
      }
      arguments = [assets_configs, basename, site, dir]
      assets = Jekyll::Favicon.send :create_assets, *arguments
      assets.size.must_equal assets_configs.size
      assets.each { |asset| asset.must_be_kind_of Jekyll::Favicon::Asset }
    end

    it 'skip a raw_asset if its value is the string `skip`' do
      assets_configs = { 'valid.png' => 'skip' }
      arguments = [assets_configs, basename, site, dir]
      assets = Jekyll::Favicon.send :create_assets, *arguments
      assets.must_be_empty
      assets_configs = { 'skip-this.png' => 'skip', 'valid.svg' => {} }
      arguments = [assets_configs, basename, site, dir]
      assets = Jekyll::Favicon.send :create_assets, *arguments
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
        arguments = [basename, site, dir, dir, basename + extname, config]
        asset = Jekyll::Favicon.send :create_asset, *arguments
        asset.must_be_kind_of Jekyll::Favicon::Assets::Image
      end
    end

    it 'creates a Jekyll::Favicon::Data asset instance if the name has a ' \
       'valid Webmanifest extension' do
      %w[.json .webmanifest].each do |extname|
        arguments = [basename, site, dir, dir, basename + extname, config]
        asset = Jekyll::Favicon.send :create_asset, *arguments
        asset.must_be_kind_of Jekyll::Favicon::Assets::Data
      end
    end

    it 'creates a Jekyll::Favicon::Markup asset instance if the name has a ' \
       'valid Browserconfig extension' do
      arguments = [basename, site, dir, dir, basename + '.xml', config]
      asset = Jekyll::Favicon.send :create_asset, *arguments
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
      assets = Jekyll::Favicon.assets site
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
      sources = Jekyll::Favicon.sources site
      sources.must_be_kind_of Set
      sources.wont_be_empty
    end
  end

  describe '.references' do
    it 'is a public method' do
      Jekyll::Favicon.must_respond_to :references
    end

    it 'collects and unifies all the references through all assets' do
      references = Jekyll::Favicon.references site
      references.must_be_kind_of Hash
      references.must_be_empty
    end
  end
end
