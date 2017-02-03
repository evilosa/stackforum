feature 'User sign in', %q{
  In order to be able to ask question
  As an user
  I want to be able to sign in
} do

  given(:user) { create(:user) }

  scenario 'Registered user try to sign in' do
    sign_in(user)

    expect(page).to have_content t('devise.sessions.signed_in')
    expect(current_path).to eq root_path
  end

  scenario 'Unregistered user try to sign in' do
    visit new_user_session_path
    fill_in t('activerecord.attributes.user.email'), with: 'wrong@test.com'
    fill_in t('activerecord.attributes.user.password'), with: '12345678'
    click_button t('common.button.log_in')

    expect(page).to have_content t('devise.failure.invalid', authentication_keys: t('activerecord.attributes.user.email'))
    expect(current_path).to eq new_user_session_path
  end

end