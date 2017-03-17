require 'spec_helper'

describe 'Answer API' do
  describe 'GET #create' do
    let(:access_token) { create(:access_token) }
    let!(:question) { create(:question) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:answer), format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:answer), format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:valid_params) { { answer: attributes_for(:answer), format: :json, access_token: access_token.token} }
      let(:invalid_params) { { answer: attributes_for(:answer, :invalid), format: :json, access_token: access_token.token } }

      let!(:create_answer) do
        Proc.new do |params = valid_params|
          post "/api/v1/questions/#{question.id}/answers", params: params
        end
      end

      context 'with valid attributes' do
        it 'returns 200 status code' do
          create_answer.call
          expect(response).to be_success
        end

        it 'save answer in database' do
          expect{ create_answer.call }.to change(Answer, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'returns 422 status code' do
          create_answer.call(invalid_params)
          expect(response.status).to eq 422
        end

        it 'not save answer in database' do
          expect{ create_answer.call(invalid_params) }.not_to change(Answer, :count)
        end
      end
    end
  end
end