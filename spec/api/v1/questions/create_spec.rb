require 'spec_helper'

describe 'Question API' do
  describe 'GET #create' do
    let(:access_token) { create(:access_token) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        post '/api/v1/questions/', params: { question: attributes_for(:question), format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        post '/api/v1/questions/', params: { question: attributes_for(:question), format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:valid_params) { { question: attributes_for(:question), format: :json, access_token: access_token.token} }
      let(:invalid_params) { { question: attributes_for(:question, :invalid), format: :json, access_token: access_token.token } }

      let!(:create_question) do
        Proc.new do |params = valid_params|
          post '/api/v1/questions', params: params
        end
      end

      context 'with valid attributes' do
        it 'returns 200 status code' do
          create_question.call
          expect(response).to be_success
        end

        it 'save question in database' do
          expect{ create_question.call }.to change(Question, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'returns 422 status code' do
          create_question.call(invalid_params)
          expect(response.status).to eq 422
        end

        it 'not save in database' do
          expect{ create_question.call(invalid_params) }.not_to change(Question, :count)
        end
      end
    end
  end
end