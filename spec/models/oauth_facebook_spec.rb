RSpec.describe User, type: :model do
  describe 'Facebook oauth' do
    let!(:user) { create(:user) }

    context 'user already has identity' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456' )}

      it 'returns the user' do
        user.identities.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not identity' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email })}

      context 'user already exists' do
        it 'does not create new user' do
          expect{ User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates identity for user' do
          expect{ User.find_for_oauth(auth) }. to change(user.identities, :count).by(1)
        end

        it 'creates identity with provider and uid' do
          user = User.find_for_oauth(auth)
          identity = user.identities.first

          expect(identity.provider).to eq auth.provider
          expect(identity.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end
    end

    context 'user does not exists' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com' })}

      it 'creates new user' do
        expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
      end

      it 'returns new user' do
        expect(User.find_for_oauth(auth)).to be_a(User)
      end

      it 'fills user email' do
        user = User.find_for_oauth(auth)
        expect(user.email).to eq auth.info.email
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
    end
  end
end