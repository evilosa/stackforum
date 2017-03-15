require 'spec_helper'

describe 'Answer API' do
  describe 'GET #index' do
    let(:access_token) { create(:access_token) }
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let!(:second_answer) { create(:answer, question: question) }
    let(:parsed_response) { JSON.parse(response.body)[1] }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}/answers/", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}/answers/", params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      before do
        get "/api/v1/questions/#{question.id}/answers/", params: { format: :json, access_token: access_token.token }
      end

      it 'returns 200 status code' do
        expect(response).to be_success
      end

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
end