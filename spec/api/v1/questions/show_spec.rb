require 'spec_helper'

describe 'Question API' do
  describe 'GET #show' do
    let(:access_token) { create(:access_token) }
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let!(:attachment) { create(:attachment, attachable: question) }
    let!(:comment) { create(:comment, commentable: question) }
    let(:parsed_response) { JSON.parse(response.body) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      before do
        get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token }
      end

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'question contains attributes' do
        expect(parsed_response['id']).to eq(question.id)
        expect(parsed_response['title']).to eq(question.title)
        expect(parsed_response['body']).to eq(question.body)
        expect(parsed_response['created_at'].to_json).to eq question.created_at.to_json
        expect(parsed_response['updated_at'].to_json).to eq question.updated_at.to_json
      end

      context 'attachments' do
        let(:parsed_attachment) { parsed_response['attachments'][0]}

        it 'included in question object' do
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

        it 'included in question object' do
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
end