feature 'Write answer for question', %q{
  In order to answer for the question
  As an authenticated user
  I want to be able to create answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question_with_answers) }

  scenario 'Authenticated user create answer for the question', js: true do
    sign_in(user)

    visit question_path(question)

    within_frame 0 do
      first('.bootsy_text_area').set('Test answer')
    end
    click_on t('common.button.question.answer')

    wait_for_ajax

    expect(current_path).to eq question_path(question)
    within '.social-footer' do
      expect(page).to have_content 'Test answer'
    end
  end

  scenario 'Unauthenticated user tries create answer for the question' do
    visit question_path(question)

    fill_in id: 'answer_body', with: 'Test answer'
    click_on t('common.button.question.answer')

    expect(page).to have_content t('devise.failure.unauthenticated')
    expect(current_path).to eq new_user_session_path
  end
end