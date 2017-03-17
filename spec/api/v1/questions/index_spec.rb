require 'spec_helper'

describe 'Question API' do
  describe 'GET #index' do
    let(:access_token) { create(:access_token) }
    it_behaves_like 'API authenticable'

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let!(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }
      let(:parsed_response) { JSON.parse(response.body)[0] }

      before do
        do_request(access_token: access_token.token)
      end

      it_behaves_like 'API successable'

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

  def do_request(params = {})
    get '/api/v1/questions', params: { format: :json }.merge(params)
  end
end