require_relative '../acceptance_helper'

feature 'Register user', %q{
  In order to be able to create question and get answer
  As an guest
  I want to be able to register
} do

  before do
    visit new_user_registration_path
  end

  let!(:fill_user) do
    Proc.new do |user, password_confirmation = user.password_confirmation|
      fill_in t('activerecord.attributes.user.email'), with: user.email
      fill_in t('activerecord.attributes.user.password'), with: user.password
      fill_in t('activerecord.attributes.user.password_confirmation'), with: password_confirmation

      click_button t('common.button.register')
    end
  end

  scenario 'Guest tries to register with valid data' do
    user = build(:user)
    fill_user.call(user)

    expect(page).to have_content t('devise.registrations.signed_up')
    expect(page).to have_current_path root_path
  end

  scenario 'Guest tries to register with invalid password confirmation' do
    user = build(:user)
    fill_user.call(user, user.password.reverse)

    expect(page).to have_content t('activerecord.errors.models.user.attributes.password_confirmation.confirmation')
    expect(page).to have_current_path user_registration_path
  end

  scenario 'User tries to register with taken email' do
    user = create(:user)
    fill_user.call(user)

    expect(page).to have_content t('activerecord.errors.models.user.attributes.email.taken')
    expect(page).to have_current_path user_registration_path
  end
end