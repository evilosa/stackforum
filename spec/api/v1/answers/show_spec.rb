require 'spec_helper'

describe 'Answers API' do
  describe 'GET #show' do
    let(:access_token) { create(:access_token) }
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let!(:attachment) { create(:attachment, attachable: answer) }
    let!(:comment) { create(:comment, commentable: answer) }
    let(:parsed_response) { JSON.parse(response.body) }

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

      context 'attachments' do
        let(:parsed_attachment) { parsed_response['attachments'][0]}

        it 'included in answer object' do
          expect(parsed_response['attachments'].size).to eq 1
        end

        it 'contains attributes' do
          expect(parsed_attachment['id']).to eq(attachment.id)
          expect(parsed_attachment['name']).to eq(attachment.file.identifier)
          expect(parsed_attachment['url']).to eq(attachment.file.url)
        end
      end

      context 'comments' do
        let(:parsed_comments) { parsed_response['comments'][0]}

        it 'included in answer object' do
          expect(parsed_response['comments'].size).to eq 1
        end

        it 'contains attributes' do
          expect(parsed_comments['id']).to eq(comment.id)
          expect(parsed_comments['body']).to eq(comment.body)
          expect(parsed_comments['created_at'].to_json).to eq comment.created_at.to_json
          expect(parsed_comments['updated_at'].to_json).to eq comment.updated_at.to_json
        end
      end
    end
  end

  def do_request(params = {})
    get "/api/v1/questions/#{question.id}/answers/#{answer.id}", params: { format: :json }.merge(params)
  end
end