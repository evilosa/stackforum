require_relative '../acceptance_helper'

feature 'Edit question', %q{
  In order to fix mistake
  As an author
  I want to be able edit question
} do

  given!(:user) { create(:user) }
  given!(:second_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:second_user_question) { create(:question, user: second_user) }

  scenario 'Unauthenticated user not see link to edit question' do
    visit question_path(question)

    expect(page).not_to have_content t('common.button.edit')
  end

  describe 'Authenticated user' do
    before do
      login_as(user, scope: :user, run_callbacks: false)
    end

    describe 'as the question owner' do
      before do
        visit question_path(question)
      end

      scenario 'sees link to edit' do
        within '.social-action' do
          expect(page).to have_content t('common.button.edit')
        end
      end

      scenario 'can edit body', js: true do
        within '.social-action' do
          find('#edit-question', match: :first).click
        end

        sleep 1
        page.execute_script("$('.wysihtml5-sandbox')[0].contentWindow.document.body.innerHTML='Test edit question';")

        find('#ready-button', match: :first).click()

        within '.social-body' do
          expect(page).to have_content 'Test edit question'
        end

        expect(current_path).to eq question_path(question)
        expect(page).not_to have_content t('common.button.ready')
      end
    end

    describe 'not as the question owner' do
      before do
        visit question_path(second_user_question)
      end

      scenario 'not sees link to edit' do
        within '.social-action' do
          expect(page).not_to have_content t('common.button.edit')
        end
      end
    end
  end
end