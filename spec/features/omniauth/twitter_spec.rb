require_relative '../acceptance_helper'

feature 'Twitter oauth', %q{
  To register on site,
  As a guest user,
  I want to be able authenticate with Twitter
} do

  describe 'Twitter user' do
    before do
      visit new_user_session_path
    end

    it 'can sign in with oauth' do
      expect(page).to have_content t('common.authentication.sign_with_provider', provider: 'Twitter')

      mock_twitter_auth_hash

      click_link t('common.authentication.sign_with_provider', provider: 'Twitter')
      expect(page).to have_current_path(omniauth_path, only_path: true)

      fill_in('email', with: 'test@stackforum.com')
      click_on t('common.button.ready')

      open_email('test@stackforum.com')
      current_email.click_link 'Confirm email'

      expect(page).to have_current_path root_path

      expect(page).to have_content('test@stackforum.com')

      expect(page).to have_content t('common.button.log_out')
    end

    it 'can not sign in with invalid credentials' do
      expect(page).to have_content t('common.authentication.sign_with_provider', provider: 'Twitter')

      OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
      click_link t('common.authentication.sign_with_provider', provider: 'Twitter')

      expect(page).to have_content t('common.authentication.sign_with_provider', provider: 'Twitter')
    end
  end

end