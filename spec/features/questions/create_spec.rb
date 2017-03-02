require_relative '../acceptance_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates question' do
    login_as(user, scope: :user, run_callbacks: false)

    visit questions_path
    click_on t('common.button.question.add_new')
    expect(page).to have_current_path new_question_path
    fill_in t('activerecord.attributes.question.title'), with: 'Test question'
    page.execute_script("$('.wysihtml5-sandbox')[0].contentWindow.document.body.innerHTML='Test question';")
    click_on t('common.button.create')

    expect(page).to have_content t('common.messages.questions.create')
  end

  context 'multiple sessions' do
    scenario "question appears on another user's page" do
      Capybara.using_session('user') do
        login_as(user, scope: :user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        visit questions_path
        click_on t('common.button.question.add_new')
        expect(page).to have_current_path new_question_path
        fill_in t('activerecord.attributes.question.title'), with: 'Test question'
        page.execute_script("$('.wysihtml5-sandbox')[0].contentWindow.document.body.innerHTML='Test question';")
        click_on t('common.button.create')

        expect(page).to have_content 'Test question'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
      end
    end
  end
  scenario 'Non-authenticated user tries to create question' do
    visit questions_path
    click_on t('common.button.question.add_new')

    expect(page).to have_content t('devise.failure.unauthenticated')
  end
end