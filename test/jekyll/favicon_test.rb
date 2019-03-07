require 'test_helper'

describe Jekyll::Favicon do
  it 'should have a version number' do
    Jekyll::Favicon::VERSION.wont_be_nil
  end

  it 'should have a config parameter' do
    Jekyll::Favicon.config.wont_be_empty
    Jekyll::Favicon.config['source'].wont_be_empty
    Jekyll::Favicon.config['path'].wont_be_nil
    Jekyll::Favicon.config['resources'].wont_be_empty
  end

  it 'should have a default parameters' do
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

  it 'should have a include' do
    # Jekyll::Favicon.include().wont_be_empty
    # Jekyll::Favicon.include()['browserconfig'].wont_be_empty
    # Jekyll::Favicon.include()['webmanifest'].wont_be_empty
  end
end
