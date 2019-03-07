require 'test_helper'

describe Jekyll::Favicon::Generator do
  before :all do
    @options = {
      'destination' => Dir.mktmpdir
    }
    @destination = @options['destination']
  end

  after :all do
    FileUtils.remove_entry @options['destination']
  end

  describe 'when site source is empty' do
    before :all do
      @options['source'] = fixture 'sites', 'empty'
      @config = Jekyll.configuration @options
      @site = Jekyll::Site.new @config
    end

    it 'should not generate files because favicon source is missing' do
      assert_output(nil, /Jekyll::Favicon: Missing favicon.svg/) do
        Jekyll.logger.log_level = :warn
        @site.process
        Jekyll.logger.log_level = :error
      end
      refute File.exist? File.join @options['destination'], 'favicon.ico'
    end
  end

  describe 'when site uses default SVG favicon' do
    before :all do
      @options['source'] = fixture 'sites', 'minimal'
      @config = Jekyll.configuration @options
      @site = Jekyll::Site.new @config
      @site.process
      @config = Jekyll::Favicon::CONFIG
    end

    it 'should create ICO favicon' do
      assert File.exist? File.join(@destination, 'favicon.ico')
    end

    it 'should create PNG favicons' do
      generated_files = Dir.glob File.join(@destination, '**', '*.png')
      options = ['generic', 'ie', 'chrome', 'apple-touch-icon']
      sizes = options.collect { |option| option['sizes'] }.compact.uniq
      sizes.each do |size|
        icon = File.join @destination, @config['path'], "favicon-#{size}.png"
        generated_files.must_include icon
      end
    end

    it 'should create a webmanifest' do
      resource = Jekyll::Favicon.resource @site, 'manifest.webmanifest'
      assert File.exist? File.join @destination, resource.endpoint
    end

    it 'should create a browserconfig' do
      resource = Jekyll::Favicon.resource @site, 'browserconfig.xml'
      assert File.exist? File.join @destination, resource.endpoint
    end
  end

  describe 'when site uses default PNG favicon' do
    before :all do
      @options['source'] = fixture 'sites', 'minimal-png-source'
      @config = Jekyll.configuration @options
      @site = Jekyll::Site.new @config
      @site.process
      @config = Jekyll::Favicon::CONFIG
    end

    it 'should create ICO favicon' do
      assert File.exist? File.join(@destination, 'favicon.ico')
    end

    it 'should create PNG favicons' do
      generated_files = Dir.glob File.join(@destination, '**', '*.png')
      options = ['generic', 'ie', 'chrome', 'apple-touch-icon']
      sizes = options.collect { |option| option['sizes'] }.compact.uniq
      sizes.each do |size|
        icon = File.join @destination, @config['path'], "favicon-#{size}.png"
        generated_files.must_include icon
      end
    end

    it 'should create a webmanifest' do
      resource = Jekyll::Favicon.resource @site, 'manifest.webmanifest'
      assert File.exist? File.join @destination, resource.endpoint
    end

    it 'should create a browserconfig' do
      resource = Jekyll::Favicon.resource @site, 'browserconfig.xml'
      assert File.exist? File.join @destination, resource.endpoint
    end
  end

  describe 'when site has an existing webmanifest at default location' do
    before :all do
      @options['source'] = fixture 'sites', 'minimal-default-webmanifest'
      @config = Jekyll.configuration @options
      @site = Jekyll::Site.new @config
      @site.process
      @config = Jekyll::Favicon::CONFIG
      resource = Jekyll::Favicon.resource @site, 'manifest.webmanifest'
      webmanifest_content = File.read File.join @destination, resource.endpoint
      @webmanifest = JSON.parse webmanifest_content
    end

    it 'should keep values from existent webmanifest' do
      @webmanifest.keys.must_include 'name'
      @webmanifest.keys.must_include 'short_name'
    end

    it 'should append icons webmanifest' do
      @webmanifest.keys.must_include 'icons'
      @webmanifest['icons'].wont_be_empty
      # p @webmanifest['icons']
      @webmanifest['icons'].size.must_equal 2
    end
  end

  describe 'when site has an existing custom configuration' do
    before :all do
      @options['source'] = fixture 'sites', 'custom-config'
      @config = Jekyll.configuration @options
      @site = Jekyll::Site.new @config
      @site.process
      @custom_config = YAML.load_file File.join @options['source'],
                                                '_config.yml'
      @custom_favicon_config = @custom_config['favicon']
      @webmanifest = Jekyll::Favicon.resource @site, 'custom.webmanifest'
      @browserconfig = Jekyll::Favicon.resource @site, 'custom.xml'
    end

    it 'should exists only one manifest' do
      refute File.file? File.join @destination, @webmanifest.source
      assert File.file? File.join @destination, @webmanifest.endpoint
    end

    it 'should merge attributes from existent webmanifest' do
      endpoint = File.join @destination, @webmanifest.endpoint
      assert File.file? endpoint
      webmanifest = JSON.parse File.read endpoint
      webmanifest.keys.must_include 'icons'
      webmanifest.keys.must_include 'name'
      webmanifest['name'].must_equal 'custom.webmanifest name'
    end

    it 'should exists only one browserconfig' do
      refute File.file? File.join @destination, @browserconfig.source
      assert File.file? File.join @destination, @browserconfig.endpoint
    end

    it 'should merge and override attributes from existent browserconfig' do
      endpoint = File.join @destination, @browserconfig.endpoint
      assert File.file? endpoint
      browserconfig = REXML::Document.new File.read endpoint
      msapplication = browserconfig.elements['/browserconfig/msapplication']
      msapplication.wont_be_nil
      tiles = msapplication.elements['tile']
      tiles.get_elements('square70x70logo').size.must_equal 1
      tiles.get_elements('TileColor').size.must_equal 1
      endpoint = File.join '', @custom_favicon_config['path'],
                           'favicon-128x128.png'
      tiles.elements['square70x70logo'].attributes['src'].must_equal endpoint
      msapplication.elements['notification'].wont_be_nil
    end
  end
end
