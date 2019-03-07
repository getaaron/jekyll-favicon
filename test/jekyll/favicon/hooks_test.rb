require 'test_helper'

describe 'Setup Favicon configuration configuration with hooks' do
  before do
    @options = { 'source' => fixture('sites', 'config') }
    @site = Jekyll::Site.new Jekyll.configuration @options
    config_raw = File.join @options['source'], '_config.yml'
    @favicon_config = YAML.load_file(config_raw)['favicon']
    @favicon_site_config = @site.config['favicon']
  end

  it 'should loads favicon config in default config file' do
    @favicon_site_config['source'].must_equal @favicon_config['source']
    @favicon_site_config['path'].must_equal @favicon_config['path']
    @favicon_site_config['background'].must_equal @favicon_config['background']
    @site.config['exclude'].must_include @favicon_config['source']
  end
end
