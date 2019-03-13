require 'test_helper'

describe 'Setup Favicon configuration configuration with hooks' do
  before :all do
    @options = { 'source' => fixture('sites', 'config') }
    @site = Jekyll::Site.new Jekyll.configuration @options
    @custom = YAML.load_file File.join @options['source'], '_config.yml'
  end

  it 'should load favicon defaults parameters' do
    Jekyll::Favicon.defaults.wont_be_nil
    Jekyll::Favicon.defaults.wont_be_empty
    defaults = Jekyll::Favicon.defaults
    defaults['processing'].wont_be_empty
    defaults['processing']['input'].wont_be_empty
    defaults['processing']['input']['.png'].wont_be_empty
    defaults['processing']['input']['.svg'].wont_be_empty
    defaults['processing']['output'].wont_be_empty
    defaults['processing']['output']['.ico'].wont_be_empty
    defaults['processing']['output']['.png'].wont_be_empty
    defaults['processing']['output']['.svg'].wont_be_empty
    defaults['tags'].wont_be_empty
    defaults['tags']['link'].wont_be_empty
    defaults['tags']['meta'].wont_be_empty
  end

  it 'should have a config parameter' do
    config = Jekyll::Favicon.config @custom['favicon']
    config.wont_be_nil
    config.wont_be_empty
    config['source'].wont_be_nil
    config['source'].must_equal @custom['favicon']['source']
    config['path'].wont_be_nil
    config['path'].must_equal @custom['favicon']['path']
    config['assets'].wont_be_nil
    config['assets'].wont_be_empty
  end

  it 'should override assets' do
    assets = Jekyll::Favicon.assets @site
    assets.wont_be_nil
    assets.size.must_equal 3
  end

  it 'should add sources to exclude' do
    @site.config['exclude'].must_include @custom['favicon']['source']
  end
end
