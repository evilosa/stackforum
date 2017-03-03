require_relative '../acceptance_helper'

feature 'Create comments for the question', %q{
  In order to comment question
  As an user
  I'd like to be able to create comment
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user' do

    before do
      login_as(user, scope: :user, run_callbacks: false)
      visit question_path(question)
    end

    scenario 'sees comment link' do
      expect(page).to have_css('#new-question-comment')
    end

    scenario 'can create comment for the question' do
      find('#new-question-comment').click

      page.execute_script("$('.wysihtml5-sandbox')[0].contentWindow.document.body.innerHTML='Test comment';")
      click_on t('common.button.ready')

      within '.comments' do
        expect(page).to have_content('Test comment')
      end
    end
  end

  describe 'Not authenticated user' do
    scenario 'not sees comment link for the question' do
      expect(page).not_to have_css('#new-question-comment')
    end
  end
end
