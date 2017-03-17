require 'spec_helper'

describe 'Answer API' do
  describe 'GET #index' do
    let(:access_token) { create(:access_token) }
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let!(:second_answer) { create(:answer, question: question) }
    let(:parsed_response) { JSON.parse(response.body)[1] }

    it_behaves_like 'API authenticable'

    context 'authorized' do
      before do
        do_request(access_token: access_token.token)
      end

      it_behaves_like 'API successable'

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2)
      end

      it 'answer from the list contains attributes' do
        expect(parsed_response['id']).to eq(answer.id)
        expect(parsed_response['body']).to eq(answer.body)
        expect(parsed_response['created_at'].to_json).to eq answer.created_at.to_json
        expect(parsed_response['updated_at'].to_json).to eq answer.updated_at.to_json
      end
    end
  end

  def do_request(params = {})
    get "/api/v1/questions/#{question.id}/answers/", params: { format: :json }.merge(params)
  end
end