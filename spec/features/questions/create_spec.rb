require_relative '../acceptance_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates question' do
    login_as(user, scope: :user)

    visit questions_path
    click_on t('common.button.question.add_new')
    fill_in t('activerecord.attributes.question.title'), with: 'Test question'
    fill_in t('activerecord.attributes.question.body'), with: 'text text'
    click_on t('common.button.create')

    expect(page).to have_content t('common.messages.questions.create')
  end

  scenario 'Non-authenticated user tries to create question' do
    visit questions_path
    click_on t('common.button.question.add_new')

    expect(page).to have_content t('devise.failure.unauthenticated')
  end
end