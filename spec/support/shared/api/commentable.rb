shared_examples_for 'API commentable' do
  context 'comments' do
    it 'included in object' do
      expect(parsed_response['comments'].size).to eq 1
    end

    it 'contains attributes' do
      expect(parsed_comments['id']).to eq(comment.id)
      expect(parsed_comments['body']).to eq(comment.body)
      expect(parsed_comments['created_at'].to_json).to eq comment.created_at.to_json
      expect(parsed_comments['updated_at'].to_json).to eq comment.updated_at.to_json
    end
  end
end