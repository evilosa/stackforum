require 'spec_helper'

describe 'Profile API' do
  describe 'GET /me' do
    let(:me) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }
    let(:parsed_response) { JSON.parse(response.body) }

    it_behaves_like 'API authenticable'

    context 'authorized' do
      before { do_request(access_token: access_token.token) }

      it_behaves_like 'API successable'

      it 'contain attributes' do
        expect(parsed_response['id']).to eq(me.id)
        expect(parsed_response['email']).to eq(me.email)
        expect(parsed_response['created_at'].to_json).to eq me.created_at.to_json
        expect(parsed_response['updated_at'].to_json).to eq me.updated_at.to_json
        expect(parsed_response['admin']).to eq me.admin
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

  def do_request(params = {})
    get '/api/v1/profiles/me', params: { format: :json }.merge(params)
  end
end