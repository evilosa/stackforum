require_relative '../acceptance_helper'

feature 'Set best answer', %q{
  In order to set best answer
  As question author
  I want to be able set best answer
} do

  given!(:user) { create(:user) }
  given!(:second_user) { create(:user) }
  given!(:question) { create(:question_with_answers, user: user) }
  given!(:other_user_question) { create(:question_with_answers, user: second_user) }

  scenario 'Unauthenticated user not sees link to set best answers' do
    visit question_path(question)

    within '.social-footer' do
      expect(page).not_to have_content t('common.button.best')
    end
  end

  describe 'Authenticated user' do
    before do
      login_as(user, scope: :user, run_callbacks: false)
    end

    describe 'as question owner' do
      given(:answer1) { create(:answer, question: question) }
      given(:answer2) { create(:answer, question: question) }
      given(:answer3) { create(:answer, question: question) }

      before do
        visit question_path(question)
      end

      scenario 'sees link to set best answer' do
        within '.social-footer' do
          expect(page).to have_content t('common.button.best')
        end
      end

      scenario 'set best answer for his question' do
        within '.social-footer' do
          find('#best-answer')[1].click
        end

        expect(current_path).to eq question_path(question)

      end

      scenario 'change best answer for his question'
    end

    describe 'not as question owner' do
      before do
        visit question_path(other_user_question)
      end

      scenario 'not sees link to set best answer' do
        within '.social-footer' do
          expect(page).not_to have_content t('common.button.best')
        end
      end
    end
  end
end