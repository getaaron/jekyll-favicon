require 'test_helper'

describe 'favicon module' do
  describe 'build environment' do
    it 'responds to build' do
      Jekyll::Favicon.must_respond_to :build
    end

    describe 'when merging' do
      before do
        @base = { a: { b: { c: [1] } } }
        @custom = { a: { b: { c: [2] } } }
      end

      it 'with override' do
        merged = Jekyll::Favicon.merge @base, @custom, override: true
        merged.must_equal a: { b: { c: [2] } }
      end

      it 'whitout override' do
        merged = Jekyll::Favicon.merge @base, @custom
        merged.must_equal a: { b: { c: [1, 2] } }
      end
    end
  end

  describe 'when favicon is built' do
    before :all do
      site = Jekyll::Site.new Jekyll.configuration
      Jekyll::Favicon.build site, (site.config['favicon'] || {})
    end

    it 'has a valid config' do
      Jekyll::Favicon.must_respond_to :config
      Jekyll::Favicon.config.wont_be_nil
      Jekyll::Favicon.config.wont_be_empty
    end

    it 'has a valid defaults' do
      Jekyll::Favicon.must_respond_to :defaults
      Jekyll::Favicon.defaults.wont_be_nil
      Jekyll::Favicon.defaults.wont_be_empty

      Jekyll::Favicon.defaults.keys.must_include 'processing'
      processing = Jekyll::Favicon.defaults['processing']
      processing.wont_be_nil
      processing.wont_be_empty
    end

    it 'has a valid assets' do
      Jekyll::Favicon.must_respond_to :assets
      assets = Jekyll::Favicon.assets
      assets.wont_be_nil
      assets.wont_be_empty
      asset = assets.find { |asset_| asset_.name.eql? 'favicon-16x16.png' }
      asset.must_be_kind_of Jekyll::Favicon::StaticFile
      config = Jekyll::Favicon.config
      asset.destination_rel_dir.must_equal config['path']
      asset.source.must_equal config['source']
      asset.sourceable?.must_equal true
    end
  end
end
