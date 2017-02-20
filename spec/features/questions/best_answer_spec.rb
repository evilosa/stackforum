require_relative '../acceptance_helper'

feature 'Set best answer', %q{
  In order to set best answer
  As question author
  I want to be able set best answer
} do

  given!(:user) { create(:user) }
  given!(:second_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:second_user_question) { create(:question_with_answers, user: second_user) }

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
      before do
        create(:answer, question: question)
        create(:answer, question: question)
        create(:answer, question: question)
        visit question_path(question)
      end

      scenario 'sees link to set best answer' do
        within '.social-footer' do
          expect(page).to have_content t('common.button.best')
        end
      end

      scenario 'set best answer for the question', js: true do
        assert_selector('#best-answer', count: 3)
        within '.social-footer' do
          find('#best-answer', match: :first).click
        end

        expect(current_path).to eq question_path(question)
        expect(page).to have_css('.badge-primary')
        assert_selector('#best-answer', count: 2)
      end

      scenario 'change best answer for his question', js: true do
        assert_selector('#best-answer', count: 3)
        within '.social-footer' do
          find('#best-answer', match: :first).click
        end

        sleep 1
        expect(current_path).to eq question_path(question)
        expect(page).to have_css('.badge-primary')
        assert_selector('#best-answer', count: 2)

        within '.social-footer' do
          find('#best-answer', match: :first).click
        end
        sleep 1
        assert_selector('#best-answer', count: 2)

        expect(current_path).to eq question_path(question)
        expect(page).to have_css('.badge-primary')
      end
    end

    describe 'not as question owner' do
      before do
        visit question_path(second_user_question)
      end

      scenario 'not sees link to set best answer' do
        within '.social-footer' do
          expect(page).not_to have_content t('common.button.best')
        end
      end
    end
  end
end