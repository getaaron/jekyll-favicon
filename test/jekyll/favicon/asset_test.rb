require 'test_helper'

describe Jekyll::Favicon::Asset do
  subject { Jekyll::Favicon::Asset.included_modules }

  it 'is mappeable' do
    subject.must_include Jekyll::Favicon::Mappeable
  end

  it 'is sourceable' do
    subject.must_include Jekyll::Favicon::Sourceable
  end

  it 'is referenceable' do
    subject.must_include Jekyll::Favicon::Referenceable
  end

  it 'is taggable' do
    subject.must_include Jekyll::Favicon::Taggable
  end

  describe '.new' do
    let(:site) { Jekyll::Site.new Jekyll.configuration }
    let(:base) { site.source }
    let(:dir) { '' }
    let(:basename) { 'basename.extname' }
    let(:attributes) do
      { 'source' => 'filename', 'dir' => '', 'name' => 'filename' }
    end

    describe 'when no asset parameters provided' do
      subject { Jekyll::Favicon::Asset.new site, attributes }

      it 'is a Jekyll::StaticFile instance' do
        subject.must_be_kind_of Jekyll::StaticFile
      end

      it 'is not sourceable' do
        subject.sourceable?.must_equal false
      end
    end
  end
end
