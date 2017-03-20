require 'spec_helper'

describe 'Answer API' do
  describe 'GET #create' do
    let(:access_token) { create(:access_token) }
    let!(:question) { create(:question) }

    it_behaves_like 'API authenticable'

    context 'authorized' do
      let(:valid_params) { { answer: attributes_for(:answer), format: :json, access_token: access_token.token} }
      let(:invalid_params) { { answer: attributes_for(:answer, :invalid), format: :json, access_token: access_token.token } }

      let!(:create_answer) do
        Proc.new do |params = valid_params|
          post "/api/v1/questions/#{question.id}/answers", params: params
        end
      end

      context 'with valid attributes' do
        before do
          create_answer.call
        end

        it_behaves_like 'API successable'

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

  def do_request(params = {}, answer = attributes_for(:answer))
    post "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(params).merge(answer: answer)
  end
end