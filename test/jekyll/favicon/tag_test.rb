require 'test_helper'

describe Jekyll::Favicon::Tag do
  before :all do
    @options = { 'destination' => Dir.mktmpdir }
  end

  after :all do
    FileUtils.remove_entry @options['destination']
  end

  describe 'using minimal configuration' do
    before :all do
      @options['source'] = fixture 'sites', 'minimal'
      jekyll_config = Jekyll.configuration @options
      @site = Jekyll::Site.new jekyll_config
      @site.process
      index_path = File.join @site.dest, 'index.html'
      @index = Nokogiri::Slop File.open index_path
    end

    it 'should generate shortcut and icon link' do
      @index.at_css('link[rel="shortcut icon"]').wont_be_nil
      @index.at_css('link[rel="icon"]').wont_be_nil
    end

    it 'should generate webmanifest link' do
      resource = Jekyll::Favicon.resource @site, 'manifest.webmanifest'
      css_selector = 'link[href="' + resource.endpoint + '"]'
      @index.css(css_selector).wont_be_nil
    end

    it 'should generate browserconfig meta' do
      resource = Jekyll::Favicon.resource @site, 'browserconfig.xml'
      css_selector = 'meta[content="' + resource.endpoint + '"]'
      @index.css(css_selector).wont_be_nil
    end

    it 'should generate metas' do
      resource = Jekyll::Favicon.resource @site, 'favicon-144x144.png'
      resource.tags.each do |tag|
        css_selector = 'meta[content="' + tag.content + '"]'
        @index.css(css_selector).wont_be_nil
      end
    end

    it 'should include safari pinned tag' do
      resource = Jekyll::Favicon.resource @site, 'safari-pinned-tab.svg'
      css_selector = 'link[ rel="mask-icon"][href="' + resource.endpoint + '"]'
      link = @index.css css_selector
      link.wont_be_nil
      link.attribute('href').value.must_equal resource.endpoint
    end
  end

  describe 'when site uses default PNG favicon' do
    before :all do
      @options['source'] = fixture 'sites', 'minimal-png-source'
      jekyll_config = Jekyll.configuration @options
      @site = Jekyll::Site.new jekyll_config
      @site.process
      index_path = File.join @site.dest, 'index.html'
      @index = Nokogiri::Slop File.open index_path
    end

    it 'should skip safari pinned tag' do
      resource = Jekyll::Favicon.resource @site, 'safari-pinned-tab.svg'
      css_selector = 'link[ rel="mask-icon"][href="' + resource.endpoint + '"]'
      refute @index.at_css(css_selector)
    end
  end

  describe 'when site uses default custom configuration' do
    before :all do
      @options['source'] = fixture 'sites', 'custom-config'
      jekyll_config = Jekyll.configuration @options
      @site = Jekyll::Site.new jekyll_config
      @site.process
      index_path = File.join @site.dest, 'index.html'
      @index = Nokogiri::Slop File.open index_path
    end

    it 'should generate ico link with custom path' do
      resource = Jekyll::Favicon.resource @site, 'favicon.ico'
      css_selector = 'link[href="' + resource.endpoint + '"]'
      @index.css(css_selector).wont_be_nil
    end
  end
end
