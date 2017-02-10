require_relative '../acceptance_helper'

feature 'User sign out', %q{
  In order to be able end session
  As an user
  I want to be able sign out
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user sign out' do
    sign_in(user)

    click_on t('common.button.log_out')
    expect(page).to have_content t('devise.sessions.signed_out')
    expect(current_path).to eq root_path
    expect(page).to have_content t('common.button.sign_in')
    expect(page).to have_content t('common.button.sign_up')
  end

  scenario 'Unauthenticated user tries sign out' do
    visit root_path

    expect(page).to have_content t('common.button.sign_in')
    expect(page).to have_content t('common.button.sign_up')
  end
end