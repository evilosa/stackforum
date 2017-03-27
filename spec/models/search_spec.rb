RSpec.describe Search do
  context '.results' do
    let(:query) { 'test query' }
    let(:params) { Hash[:classes, [Question], :page, 1, :per_page, 5] }

    after do
      Search.results(query, 'question', 1)
    end

    it 'calls escape request' do
      expect(ThinkingSphinx::Query).to receive(:escape).with(query).and_call_original
    end

    it 'calls ThinkingSphinx.search' do
      expect(ThinkingSphinx).to receive(:search).with(query, params).and_call_original
    end
  end
end