require 'spec_helper'

describe 'Profile API' do
  describe 'GET /profiles' do
    let(:me) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }
    let!(:other_users) { create_list(:user, 2)}

    it_behaves_like 'API authenticable'

    context 'authorized' do
      before { do_request(access_token: access_token.token) }

      it 'contains users' do
        expect(response.body).to be_json_eql(other_users.to_json)
      end

      it 'does not contain me' do
        JSON.parse(response.body).each do |item|
          expect(item[:id]).to_not eq me.id
        end
      end
    end
  end

  def do_request(params = {})
    get '/api/v1/profiles', params: { format: :json }.merge(params)
  end
end