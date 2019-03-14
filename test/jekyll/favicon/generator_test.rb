require 'test_helper'

describe Jekyll::Favicon::Generator do
  around :all do |&block|
    Dir.mktmpdir do |dir|
      @options = { 'destination' => dir }
      super(&block)
    end
  end

  describe "when the site doesn't have a source file" do
    before :all do
      @options['source'] = fixture 'sites', 'empty'
      site = Jekyll::Site.new Jekyll.configuration @options
      site.process
    end

    it "should not create any resource's names in config" do
      Jekyll::Favicon.config['assets'].each do |name, _|
        path = File.join @options['destination'], name
        File.file?(path).must_equal false
      end
    end
  end

  describe 'when the site uses all default configs' do
    before :all do
      @options['source'] = fixture 'sites', 'minimal'
      @site = Jekyll::Site.new Jekyll.configuration @options
      @site.process
    end

    it "creates all assets' names and files in config" do
      Jekyll::Favicon.config['assets'].each do |name, _|
        static_files_names = @site.static_files.collect(&:name)
        static_files_names.must_include name
        dest_path = File.join @options['destination'], name
        File.file?(dest_path).must_equal true
      end
    end

    it 'creates a valid JSON Webmanifest' do
      path = File.join @options['destination'], 'manifest.webmanifest'
      File.file?(path).must_equal true
      content = JSON.parse File.read path
      content.must_be_kind_of Hash
      icons = content['icons']
      icons.must_be_kind_of Array
      icons_names = icons.collect { |icon| icon['src'] }
      icons_names.must_include '/favicon-512x512.png'
    end

    it 'creates a valid XML Browserconfig' do
      path = File.join @options['destination'], 'browserconfig.xml'
      File.file?(path).must_equal true
      content = REXML::Document.new File.read path
      tiles = content.elements['/browserconfig/msapplication/tile']
      tiles.must_be_kind_of REXML::Element
      tiles.get_elements('square70x70logo').size.must_equal 1
      tile = tiles.elements['square70x70logo']
      tile.must_be_kind_of REXML::Element
      tile.attributes['src'].must_equal '/favicon-128x128.png'
      tiles.get_elements('TileColor').size.must_equal 1
    end
  end

  describe 'when the site uses default PNG favicon' do
    before :all do
      @options['source'] = fixture 'sites', 'minimal-png-source'
      @site = Jekyll::Site.new Jekyll.configuration @options
      @site.process
      @config = Jekyll::Favicon.config
    end

    it 'creates an ICO favicon' do
      File.file?(File.join(@site.dest, 'favicon.ico')).must_equal true
    end

    it 'creates a PNG favicons' do
      png_paths = Dir.glob File.join(@site.dest, '**', '*.png')
      png_names = png_paths.collect { |path| File.basename path }
      assets = Jekyll::Favicon.assets @site
      png_assets = assets.select { |asset| '.png'.eql? asset.extname }
      png_assets.each do |asset|
        png_names.must_include asset.name
      end
    end

    it 'creates a Webmanifest' do
      webmanifest_asset = Jekyll::Favicon.assets(@site).find do |asset|
        'manifest.webmanifest'.eql? asset.name
      end
      path = File.join @site.dest, webmanifest_asset.name
      File.file?(path).must_equal true
    end

    it 'creates a Browserconfig' do
      browserconfig_asset = Jekyll::Favicon.assets(@site).find do |asset|
        'browserconfig.xml'.eql? asset.name
      end
      path = File.join @site.dest, browserconfig_asset.name
      File.file?(path).must_equal true
    end
  end

  describe 'when the site has a Webmanifest at the default location' do
    before :all do
      @options['source'] = fixture 'sites', 'minimal-default-webmanifest'
      @site = Jekyll::Site.new Jekyll.configuration @options
      @site.process
      webmanifest_asset = Jekyll::Favicon.assets(@site).find do |asset|
        'manifest.webmanifest'.eql? asset.name
      end
      path = File.join @options['destination'], webmanifest_asset.name
      @content = JSON.parse File.read path
    end

    it 'keeps values from existing Webmanifest' do
      path = File.join @options['source'], 'manifest.webmanifest'
      existing_content = JSON.parse File.read path
      existing_content.each do |property, value|
        @content.must_include property
        @content[property].must_equal value
      end
    end

    it 'appends icons to webmanifest' do
      @content.must_include 'icons'
      @content['icons'].wont_be_empty
      @content['icons'].size.must_equal 2
    end
  end

  describe 'when the site already has a Webmanifest and a Browserconfig' do
    before :all do
      @options['source'] = fixture 'sites', 'custom-config'
      @site = Jekyll::Site.new Jekyll.configuration @options
      @site.process
      @user_config = YAML.load_file File.join @options['source'], '_config.yml'
    end

    let(:webmanifest_path) do
      File.join @options['destination'], 'assets/objects', 'custom.webmanifest'
    end

    it 'creates only one webmanifest' do
      File.file?(webmanifest_path).must_equal true
      overwritten_path = File.join @options['destination'], 'data/source.json'
      File.file?(overwritten_path).must_equal false
    end

    it 'merges new attributes to existent webmanifest' do
      content = JSON.parse File.read webmanifest_path
      original_path = File.join @options['source'], 'data/source.json'
      existing_content = JSON.parse File.read original_path
      existing_content.each do |property, value|
        content.must_include property
        content[property].must_equal value
      end
      content.must_include 'icons'
    end

    let(:browserconfig_path) do
      File.join @options['destination'], 'assets/markup', 'custom.xml'
    end

    it 'creates only one Browserconfig' do
      File.file?(browserconfig_path).must_equal true
      overwritten_path = File.join @options['destination'], 'data/source.xml'
      File.file?(overwritten_path).must_equal false
    end

    it 'merges new attributes to existent Browserconfig' do
      content = REXML::Document.new File.read browserconfig_path
      original_path = File.join @options['source'], 'data/source.xml'
      original_content = REXML::Document.new File.read original_path
      tiles_path = '/browserconfig/msapplication/tile'
      tiles = content.elements[tiles_path].elements
      tiles['square70x70logo'].must_be_kind_of REXML::Element
      tiles['TileColor'].must_be_kind_of REXML::Element
      path = File.join '', @user_config['favicon']['path'],
                       'favicon-128x128.png'
      tiles['square70x70logo'].attributes['src'].must_equal path
      original_tiles = original_content.elements[tiles_path]
      original_tiles.each_element_with_attribute('src') do |original_tile|
        src = tiles[original_tile.name].attributes['src']
        original_tile.attributes['src'].wont_equal src
      end
      notifications_path = '/browserconfig/msapplication/notification'
      notifications = content.elements[notifications_path].elements
      original_notifications = original_content.elements[notifications_path]
      original_notifications.each_element do |original_notification|
        notification = notifications[original_notification.name]
        original_notification.inspect.must_equal notification.inspect
      end
    end
  end
end
