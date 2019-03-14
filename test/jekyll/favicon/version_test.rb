require 'test_helper'

describe 'favicon version' do
  it 'has a version number' do
    Jekyll::Favicon::VERSION.wont_be_nil
  end
end
