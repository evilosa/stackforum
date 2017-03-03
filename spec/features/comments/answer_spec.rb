require_relative '../acceptance_helper'

feature 'Create comments for the answer', %q{
  In order to comment answer
  As an user
  I'd like to be able to create comment
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user' do

    before do
      login_as(user, scope: :user, run_callbacks: false)
      visit question_path(question)
    end

    scenario 'sees comment link' do
      expect(page).to have_css('#new-answer-comment')
    end

    scenario 'can create comment for the answer' do
      find('#new-answer-comment').click

      page.execute_script("$('.wysihtml5-sandbox')[0].contentWindow.document.body.innerHTML='Test comment';")
      click_on t('common.button.ready')

      within ".comments[data-answer-id='#{answer.id}']" do
        expect(page).to have_content('Test comment')
      end
    end
  end

  describe 'Not authenticated user' do
    scenario 'not sees comment link for the answer' do
      expect(page).not_to have_css('#new-answer-comment')
    end
  end
end
