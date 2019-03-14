require 'test_helper'

describe 'favicon hooks execution' do
  before :all do
    @options = { 'source' => fixture('sites', 'config') }
    @site = Jekyll::Site.new Jekyll.configuration @options
    @user_config = YAML.load_file File.join @options['source'], '_config.yml'
  end

  it 'adds sources to exclude' do
    @site.config['exclude'].must_include @user_config['favicon']['source']
  end
end
