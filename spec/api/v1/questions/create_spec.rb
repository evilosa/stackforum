require 'spec_helper'

describe 'Question API' do
  describe 'GET #create' do
    let(:access_token) { create(:access_token) }

    it_behaves_like 'API authenticable'

    context 'authorized' do
      let(:valid_params) { { question: attributes_for(:question), format: :json, access_token: access_token.token} }
      let(:invalid_params) { { question: attributes_for(:question, :invalid), format: :json, access_token: access_token.token } }

      let!(:create_question) do
        Proc.new do |params = valid_params|
          post '/api/v1/questions', params: params
        end
      end

      context 'with valid attributes' do
        before { create_question.call }
        it_behaves_like 'API successable'

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

  def do_request(params = {}, question = attributes_for(:question))
    post '/api/v1/questions/', params: { format: :json }.merge(params).merge(question: question)
  end
end