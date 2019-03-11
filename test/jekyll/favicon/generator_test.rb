require 'test_helper'

describe 'create files with a generator' do
  before :all do
    @options = { 'destination' => Dir.mktmpdir }
  end

  after :all do
    FileUtils.remove_entry @options['destination']
  end

  describe 'when a site uses default all default configs' do
    before :all do
      @options['source'] = fixture 'sites', 'minimal'
      site = Jekyll::Site.new Jekyll.configuration @options
      site.process
    end

    it "should create all resource's names in config" do
      Jekyll::Favicon.must_respond_to :config
      Jekyll::Favicon.config.wont_be_nil
      Jekyll::Favicon.config['assets'].wont_be_nil
      Jekyll::Favicon.config['assets'].wont_be_empty
      Jekyll::Favicon.config['assets'].each do |name, _|
        assert File.file? File.join @options['destination'], name
      end
    end

    it 'should create valid json webmanifest' do
      path = File.join @options['destination'], 'manifest.webmanifest'
      assert File.file? path
      content = JSON.parse File.read path
      content.wont_be_nil
      icons = content['icons']
      icons.wont_be_empty
      icon = icons.first
      icon['src'].must_equal '/favicon-512x512.png'
    end

    it 'should create valid xml browserconfig' do
      path = File.join @options['destination'], 'browserconfig.xml'
      assert File.file? path
      content = REXML::Document.new File.read path
      content.wont_be_nil
      tiles = content.elements['/browserconfig/msapplication/tile']
      tiles.wont_be_nil
      tiles.get_elements('square70x70logo').size.must_equal 1
      tile = tiles.elements['square70x70logo']
      tile.wont_be_nil
      tile.attributes['src'].must_equal '/favicon-128x128.png'
      tiles.get_elements('TileColor').size.must_equal 1
    end
  end
end
