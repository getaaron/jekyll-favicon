require 'test_helper'

describe 'contains favicon resources' do
  it 'should have a version number' do
    Jekyll::Favicon::VERSION.wont_be_nil
  end
end
