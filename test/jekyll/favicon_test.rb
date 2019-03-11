require 'test_helper'

describe 'favicon module' do
  it 'responds to build' do
    Jekyll::Favicon.must_respond_to :build
  end

  describe 'when favicon is built' do
    before :all do
      site = Jekyll::Site.new Jekyll.configuration
      Jekyll::Favicon.build site
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
      Jekyll::Favicon.assets.wont_be_nil
      Jekyll::Favicon.assets.wont_be_empty
    end
  end
end
