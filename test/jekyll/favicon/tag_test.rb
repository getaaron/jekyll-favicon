require 'test_helper'

describe Jekyll::Favicon::Tag do
  let(:tag) do
    Jekyll::Favicon::Tag.parse '{% favicon %}', nil, nil,
                               Liquid::ParseContext.new
  end
  let(:context) { Liquid::Context.new({}, {}, site: site) }
  let(:site) { Jekyll::Site.new Jekyll.configuration user_config }
  let(:user_config) do
    {
      'source' => source,
      'destination' => destination,
      'favicon' => { 'override' => user_override, 'assets' => user_assets }
    }
  end
  let(:source) { fixture 'sites', 'minimal' }
  let(:destination) { @destination }

  describe '.render' do
    around :all do |&block|
      Dir.mktmpdir do |tmpdir|
        @destination = tmpdir
        @tag = Jekyll::Favicon::Tag.parse '{% favicon %}', nil, nil,
                                          Liquid::ParseContext.new
        site.process
        @content = @tag.render context
        super(&block)
      end
    end

    describe 'when the site the default assets' do
      let(:user_override) { false }
      let(:user_assets) { {} }

      it 'render all default assets' do
        @content.wont_be_empty
      end
    end

    describe 'when the site noes not have assets' do
      let(:user_override) { true }
      let(:user_assets) {}

      it 'render nothing' do
        @content.must_be_empty
      end
    end

    describe 'when the site has a favicon without customization' do
      let(:user_override) { true }
      let(:user_assets) { { 'favicon-128x128.ico' => '' } }

      it 'render something' do
        element = REXML::Element.new 'link'
        element.add_attributes 'href' => '/favicon-128x128.ico',
                               'rel' => 'icon',
                               'type' => 'image/x-icon'
        @content.wont_be_empty
        @content.size.must_equal 1
        @content.inspect.must_equal [element].inspect
      end
    end

    describe 'when the site has a favicon non valid asset' do
      let(:user_override) { true }
      let(:user_assets) { { 'favicon.ico' => '' } }

      it 'render something' do
        @content.must_be_empty
      end
    end
  end
end
