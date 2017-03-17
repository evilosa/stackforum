require 'spec_helper'

describe 'Answers API' do
  describe 'GET #show' do
    let(:access_token) { create(:access_token) }
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let!(:attachment) { create(:attachment, attachable: answer) }
    let!(:comment) { create(:comment, commentable: answer) }
    let(:parsed_response) { JSON.parse(response.body) }
    let(:parsed_attachment) { parsed_response['attachments'][0]}
    let(:parsed_comments) { parsed_response['comments'][0]}

    it_behaves_like 'API authenticable'

    context 'authorized' do
      before do
        do_request(access_token: access_token.token)
      end

      it_behaves_like 'API successable'

      it 'answer contains attributes' do
        expect(parsed_response['id']).to eq(answer.id)
        expect(parsed_response['body']).to eq(answer.body)
        expect(parsed_response['created_at'].to_json).to eq answer.created_at.to_json
        expect(parsed_response['updated_at'].to_json).to eq answer.updated_at.to_json
      end

      it_behaves_like 'API attachable'
      it_behaves_like 'API commentable'
    end
  end

  def do_request(params = {})
    get "/api/v1/questions/#{question.id}/answers/#{answer.id}", params: { format: :json }.merge(params)
  end
end