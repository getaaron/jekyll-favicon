require 'test_helper'

describe Jekyll::Favicon do
  before :all do
    @site = Jekyll::Site.new Jekyll.configuration
    @source = 'valid.svg'
    @base = ''
    @dir = ''
    @name = 'invalid.txt'
    @custom = {}
  end

  describe '.build' do
    it 'responds to' do
      Jekyll::Favicon.must_respond_to :build
    end

    describe 'when building with empty site' do
      before :all do
        Jekyll::Favicon.build @site, {}
      end

      it 'sets a config hash' do
        Jekyll::Favicon.must_respond_to :config
        config = Jekyll::Favicon.config
        config.wont_be_nil
        config.wont_be_empty
      end

      it 'sets a defaults hash' do
        Jekyll::Favicon.must_respond_to :defaults
        defaults = Jekyll::Favicon.defaults
        defaults.wont_be_nil
        defaults.wont_be_empty
        defaults.keys.must_include 'processing'
        processing = defaults['processing']
        processing.wont_be_nil
        processing.wont_be_empty
      end

      it 'sets a valid assets collection' do
        Jekyll::Favicon.must_respond_to :assets
        assets = Jekyll::Favicon.assets
        assets.wont_be_nil
        assets.wont_be_empty
        assets.each do |asset|
          asset.must_be_kind_of Jekyll::Favicon::StaticFile
        end
      end
    end
  end

  describe '.config' do
  end

  describe '.defaults' do
  end

  describe '.assets' do
  end

  describe '.sources' do
  end

  describe '.references' do
  end

  describe '.merge' do
    describe "when merging custom's arrays/hashes into base" do
      before do
        @base = { a: { b: { c: [1] } } }
        @custom = { a: { b: { c: [2], d: 3 } } }
      end

      it 'responds to' do
        Jekyll::Favicon.must_respond_to :merge
      end

      it 'joins them' do
        merged = Jekyll::Favicon.merge @base, @custom
        merged.must_equal a: { b: { c: [1, 2], d: 3 } }
      end

      it 'replaces them if override is provided' do
        merged = Jekyll::Favicon.merge @base, @custom, override: true
        merged.must_equal a: { b: { c: [2], d: 3 } }
      end
    end
  end

  describe '.create_assets' do
    it 'responds using send' do
      Jekyll::Favicon.must_respond_to :send, :create_assets
    end

    describe 'maps an hash to an SourcedStaticFile collection' do
      it 'create an empty collection if a empty hash is provided' do
        assets = Jekyll::Favicon.send :create_assets, {}, @source, @site, @dir
        assets.wont_be_nil
        assets.must_be_empty
      end

      it "create assets if raw_asset's values are hashes or nil" do
        raw_assets = { 'valid.png' => {}, 'valid.ico' => nil }
        assets = Jekyll::Favicon.send :create_assets, raw_assets, @source,
                                      @site, @dir
        assets.size.must_equal raw_assets.size
        assets.each do |asset|
          asset.must_be_kind_of Jekyll::Favicon::StaticFile
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
      it 'create a Image if name is a image' do
        %w[.png .ico .svg].each do |extname|
          asset = Jekyll::Favicon.send :create_asset, @source, @site, @base,
                                       @dir, @name + extname, @custom
          asset.must_be_kind_of Jekyll::Favicon::Image
        end
      end

      it 'create a Data if name is a json file' do
        %w[.json .webmanifest].each do |extname|
          asset = Jekyll::Favicon.send :create_asset, @source, @site, @base,
                                       @dir, @name + extname, @custom
          asset.must_be_kind_of Jekyll::Favicon::Data
        end
      end

      it 'create a Markup if name is a xml file' do
        asset = Jekyll::Favicon.send :create_asset, @source, @site, @base,
                                     @dir, @name + '.xml', @custom
        asset.must_be_kind_of Jekyll::Favicon::Markup
      end
    end
  end
end
