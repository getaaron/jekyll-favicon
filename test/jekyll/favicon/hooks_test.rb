require 'test_helper'

describe 'Setup Favicon configuration configuration with hooks' do
  before :all do
    @options = { 'source' => fixture('sites', 'config') }
    @site = Jekyll::Site.new Jekyll.configuration @options
    @custom = YAML.load_file File.join @options['source'], '_config.yml'
  end

  it 'should load favicon defaults parameters' do
    Jekyll::Favicon.must_respond_to :defaults
    Jekyll::Favicon.defaults.wont_be_nil
    Jekyll::Favicon.defaults.wont_be_empty
    Jekyll::Favicon.defaults['processing'].wont_be_empty
    Jekyll::Favicon.defaults['processing']['input'].wont_be_empty
    Jekyll::Favicon.defaults['processing']['input']['.png'].wont_be_empty
    Jekyll::Favicon.defaults['processing']['input']['.svg'].wont_be_empty
    Jekyll::Favicon.defaults['processing']['output'].wont_be_empty
    Jekyll::Favicon.defaults['processing']['output']['.ico'].wont_be_empty
    Jekyll::Favicon.defaults['processing']['output']['.png'].wont_be_empty
    Jekyll::Favicon.defaults['processing']['output']['.svg'].wont_be_empty
    Jekyll::Favicon.defaults['tags'].wont_be_empty
    Jekyll::Favicon.defaults['tags']['link'].wont_be_empty
    Jekyll::Favicon.defaults['tags']['meta'].wont_be_empty
  end

  it 'should have a config parameter' do
    Jekyll::Favicon.must_respond_to :config
    Jekyll::Favicon.config.wont_be_nil
    Jekyll::Favicon.config.wont_be_empty
    Jekyll::Favicon.config['source'].wont_be_nil
    Jekyll::Favicon.config['source'].must_equal @custom['favicon']['source']
    Jekyll::Favicon.config['path'].wont_be_nil
    Jekyll::Favicon.config['path'].must_equal @custom['favicon']['path']
    Jekyll::Favicon.config['assets'].wont_be_nil
    Jekyll::Favicon.config['assets'].wont_be_empty
  end

  it 'should add sources to exclude' do
    @site.config['exclude'].must_include @custom['favicon']['source']
  end
end
