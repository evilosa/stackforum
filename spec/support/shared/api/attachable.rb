shared_examples_for 'API attachable' do
  context 'attachments' do
    it 'included in question object' do
      expect(parsed_response['attachments'].size).to eq 1
    end

    it 'contains attributes' do
      expect(parsed_attachment['id']).to eq(attachment.id)
      expect(parsed_attachment['name']).to eq(attachment.file.identifier)
      expect(parsed_attachment['url']).to eq(attachment.file.url)
    end
  end
end