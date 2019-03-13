require 'test_helper'

describe Jekyll::Favicon::Utils do
  describe '.merge' do
    describe "when merging custom's arrays/hashes into base" do
      before do
        @base = { a: { b: { c: [1] } } }
        @custom = { a: { b: { c: [2], d: 3 } } }
      end

      it 'responds to' do
        Jekyll::Favicon::Utils.must_respond_to :merge
      end

      it 'joins them' do
        merged = Jekyll::Favicon::Utils.merge @base, @custom
        merged.must_equal a: { b: { c: [1, 2], d: 3 } }
      end

      it 'replaces them if override is provided' do
        merged = Jekyll::Favicon::Utils.merge @base, @custom, override: true
        merged.must_equal a: { b: { c: [2], d: 3 } }
      end
    end
  end
end
