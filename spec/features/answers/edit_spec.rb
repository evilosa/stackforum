require_relative '../acceptance_helper'

feature 'Edit answer', %q{
  In order to fix mistake
  As an author
  I want to be able edit answer
} do

  given!(:user) { create(:user) }
  given(:second_user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Unauthenticated user not sees edit link for answers' do
    create(:answer, question: question, user: user)
    create(:answer, question: question, user: second_user)

    visit question_path(question)

    within '.social-footer' do
      expect(page).to_not have_content t('common.button.edit')
    end
  end

  describe 'Authenticated user', js: true do
    before do
      sign_in user
    end

    context 'answers belongs to user' do
      given!(:answer) { create(:answer, question: question, user: user) }

      scenario 'sees link to edit answer' do
        visit question_path(question)

        within '.social-footer' do
          expect(page).to have_content t('common.button.edit')
        end
      end

      scenario 'can edit his answer' do
        visit question_path(question)

        within '.social-footer' do
          click_on t('common.button.edit')
        end

        within_frame 0 do
          first('.bootsy_text_area').set('Edited answer text')
        end

        click_on t('common.button.ready')

        expect(current_path).to eq question_path(question)
        expect(page).not_to have_content t('common.button.ready')
        within '.social-footer' do
          expect(page).to have_content 'Edited answer text'
        end

      end
    end

    context 'answers not belongs to user' do
      given!(:answer) { create(:answer, question: question, user: second_user)}

      scenario 'not sees link to edit' do
        visit question_path(question)

        within '.social-footer' do
          expect(page).to_not have_content t('common.button.edit')
        end
      end

    end

  end
end