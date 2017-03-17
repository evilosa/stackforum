require 'spec_helper'

describe 'Question API' do
  describe 'GET #index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions', params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let!(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }
      let(:parsed_response) { JSON.parse(response.body)[0] }

      before do
        get '/api/v1/questions', params: { format: :json, access_token: access_token.token }
      end

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2)
      end

      it 'question from the list contains attributes' do
        expect(parsed_response['id']).to eq(question.id)
        expect(parsed_response['title']).to eq(question.title)
        expect(parsed_response['body']).to eq(question.body)
        expect(parsed_response['created_at'].to_json).to eq question.created_at.to_json
        expect(parsed_response['updated_at'].to_json).to eq question.updated_at.to_json
      end
    end
  end
end