require 'test_helper'

describe Jekyll::Favicon::Utils do
  it 'has public method merge' do
    Jekyll::Favicon::Utils.must_respond_to :merge
  end

  describe '.merge' do
    let(:base) { Hash.new a: { b: { c: [1] } } }
    let(:custom) { Hash.new a: { b: { c: [2], d: 3 } } }

    it 'joins two hashes if no override parameter is used' do
      merged = Jekyll::Favicon::Utils.merge @base, @custom
      merged.must_equal a: { b: { c: [1, 2], d: 3 } }
    end

    it 'merge and replaces values from the right into the left ' \
       'if the override is provided' do
      merged = Jekyll::Favicon::Utils.merge @base, @custom, override: true
      merged.must_equal a: { b: { c: [2], d: 3 } }
    end
  end
end
