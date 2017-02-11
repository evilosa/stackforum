require_relative '../acceptance_helper'

feature 'Delete answer for question', %q{
  In order to remove bad answer for the question
  As an answer owner
  I want to be able remove answer
} do

  given!(:user) { create(:user) }
  given(:second_user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Unauthenticated user not sees edit link for answers' do
    create(:answer, question: question, user: user)
    create(:answer, question: question, user: second_user)

    visit question_path(question)

    within '.social-footer' do
      expect(page).to_not have_content t('common.button.delete')
    end
  end

  describe 'Authenticated user' do
    before do
      sign_in user
    end

    context 'Answer belongs to user' do
      given!(:answer) { create(:answer, question: question, user: user) }

      scenario 'sees link to remove' do
        visit question_path(question)

        within '.social-footer' do
          expect(page).to have_content t('common.button.delete')
        end
      end

      scenario 'can remove his answer' do
        visit question_path(question)

        first('#remove_answer').click
        expect(page).to have_content t('common.messages.answers.destroy')
        expect(current_path).to eq question_path(question)
      end

    end

    context 'answers not belongs to user' do
      given!(:answer) { create(:answer, question: question, user: second_user)}

      scenario 'not sees link to remove' do
        visit question_path(question)

        within '.social-footer' do
          expect(page).to_not have_content t('common.button.delete')
        end
      end
    end

  end
end