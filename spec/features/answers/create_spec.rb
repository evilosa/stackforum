require_relative '../acceptance_helper'

feature 'Write answer for question', %q{
  In order to answer for the question
  As an authenticated user
  I want to be able to create answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question_with_answers) }

  scenario 'Authenticated user create answer for the question', js: true do
    login_as(user, scope: :user, run_callbacks: false)

    visit question_path(question)

    click_on t('common.button.answer.add_new')

    sleep 1

    page.execute_script("$('.wysihtml5-sandbox')[0].contentWindow.document.body.innerHTML='Test answer';")

    click_on t('common.button.ready')

    expect(current_path).to eq question_path(question)
    expect(page).not_to have_content t('common.button.ready')
    within '.social-footer' do
      expect(page).to have_content 'Test answer'
    end

  end

  scenario 'Unauthenticated user tries create answer for the question', js: true do
    visit question_path(question)
    expect(page).to have_content t('common.button.answer.add_new')
  end
end