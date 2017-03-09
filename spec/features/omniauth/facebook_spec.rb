require_relative '../acceptance_helper'

feature 'Facebook oauth', %q{
  To register on site,
  As a guest user,
  I want to be able authenticate with Facebook
} do

  describe 'Facebook user' do
    before do
      visit new_user_session_path
    end

    it 'can sign in with oauth' do
      expect(page).to have_content t('common.authentication.sign_with_provider', provider: 'Facebook')

      mock_facebook_auth_hash('test@stackforum.com')

      click_link t('common.authentication.sign_with_provider', provider: 'Facebook')
      expect(page).to have_content('test@stackforum.com')

      expect(page).to have_content t('common.button.log_out')
    end

    it 'can not sign in with invalid credentials' do
      expect(page).to have_content t('common.authentication.sign_with_provider', provider: 'Facebook')

      OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
      click_link t('common.authentication.sign_with_provider', provider: 'Facebook')

      expect(page).to have_content t('common.authentication.sign_with_provider', provider: 'Facebook')
    end
  end

end