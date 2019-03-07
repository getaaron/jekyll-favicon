require 'test_helper'

describe Resource do
  before :all do
    @options = {}
    @options['source'] = fixture 'sites', 'minimal'
    @config = Jekyll.configuration @options
    @site = Jekyll::Site.new @config
    @source = Jekyll::Favicon.source
    @baseurl = @site.baseurl || ''
    @path = Jekyll::Favicon.path
    @basename = 'an-icon.ico'
  end

  it 'should reject empty or nil source' do
    -> { Resource.new @site, '', '', @basename }.must_raise ArgumentError
    -> { Resource.new @site, [], '', @basename }.must_raise ArgumentError
    -> { Resource.new @site, nil, '', @basename }.must_raise ArgumentError
    -> { Resource.new @site, 'icon.xs', '', @basename }.must_raise ArgumentError
  end

  it 'should reject empty or nil basename' do
    -> { Resource.new @site, @source, '', '' }.must_raise ArgumentError
    -> { Resource.new @site, 'lala.svg', '', [] }.must_raise ArgumentError
    -> { Resource.new @site, @source, '', nil }.must_raise ArgumentError
    -> { Resource.new @site, @source, '', 'icon.xs' }.must_raise ArgumentError
  end

  it 'should create a resource using valid parameters' do
    resource = Resource.new @site, @source, @path, @basename
    resource.must_be_instance_of Resource
    resource.must_respond_to :site
    resource.must_respond_to :source
    resource.must_respond_to :path
    resource.must_respond_to :basename
    resource.must_respond_to :sizes
    resource.must_respond_to :tags
    resource.source.wont_be_nil
    resource.site.wont_be_nil
    resource.path.wont_be_nil
    resource.basename.wont_be_nil
    resource.sizes.must_be_nil
    resource.tags.wont_be_nil
    resource.source.must_equal @source
    resource.path.must_equal @path
    resource.basename.must_equal @basename
    resource.tags.first.must_be_instance_of Link
  end

  it 'should ensure link for processable target' do
    %w[.svg .png .ico .webmanifest .json].each do |extname|
      @basename = "favicon-1x1#{extname}"
      resource = Resource.new @site, @source, @path, @basename
      tags = resource.tags
      tags.wont_be_empty
      tags.size.must_equal 1
      link = Link.new resource
      tags.first.to_s.must_equal link .to_s
    end
  end

  it 'should not ensure link for non processable target' do
    %w[.xml].each do |extname|
      @basename = "favicon-2x2#{extname}"
      resource = Resource.new @site, @source, @path, @basename
      resource.links.must_be_empty
    end
  end

  it 'should not ensure extra link if custom link is provided' do
    %w[.svg .png .ico .webmanifest].each do |extname|
      @basename = "favicon-3x3#{extname}"
      custom = { 'links' => [{ 'rel' => 'test' }] }
      resource = Resource.new @site, @source, @path, @basename, custom
      links = resource.links
      links.wont_be_empty
      links.size.must_equal 1
      links.first.rel.must_equal custom['links'].first['rel']
    end
  end

  it 'should extract sizes from basename' do
    @basename = 'favicon-4x4.png'
    resource = Resource.new @site, @source, @path, @basename
    custom_sizes = ['4x4']
    resource.sizes.must_equal custom_sizes
    resource.links.first.sizes.must_equal custom_sizes.join(' ')
  end

  it 'should preserve custom config sizes' do
    @basename = 'favicon-5x5.png'
    custom = { 'sizes' => ['6x6'] }
    resource = Resource.new @site, @source, @path, @basename, custom
    resource.sizes.must_equal custom['sizes']
    resource.links.first.sizes.must_equal custom['sizes'].join(' ')
  end

  it 'should preserve custom config path' do
    @basename = 'favicon-7x7.png'
    custom = { 'path' => 'a/new/path' }
    resource = Resource.new @site, @source, @path, @basename, custom
    resource.path.must_equal custom['path']
    href = File.join @baseurl, custom['path'], @basename
    links = resource.links
    links.wont_be_empty
    links.first.href.must_equal href
  end

  it 'should load metas' do
    @basename = 'favicon-8x8.png'
    custom = {
      'metas' => [{ 'name' => 'the name', 'content' => 'the content' }]
    }
    resource = Resource.new @site, @source, @path, @basename, custom
    metas = resource.metas
    metas.wont_be_empty
    metas.size.must_equal 1
    metas.first.name.must_equal custom['metas'].first['name']
    metas.first.content.must_equal custom['metas'].first['content']
  end
end
