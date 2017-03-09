RSpec.describe User, type: :model do
  describe 'Twitter oauth' do
    let!(:auth) { OmniAuth::AuthHash.new(provider: 'twitter', uid: '123456') }

    context 'user already has identity' do
      let(:user) { create(:user) }

      it 'returns the user' do
        user.identities.create(provider: 'twitter', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not identity' do
      it 'create temp user' do
        expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
      end

      it 'creates identity for user' do
        user = User.find_for_oauth(auth)
        expect(user.identities).to_not be_empty
      end

      it 'creates identity with provider and uid' do
        identity = User.find_for_oauth(auth).identities.first
        expect(identity.provider).to eq auth.provider
        expect(identity.uid).to eq auth.uid
      end

      it 'returns the user' do
        expect(User.find_for_oauth(auth)).to be_a(User)
      end
    end
  end
end
