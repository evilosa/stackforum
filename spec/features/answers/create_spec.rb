feature 'Write answer for question', %q{
  In order to answer for the question
  As a authenticated user
  I want to be able to create answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question_with_answers) }

  scenario 'Authenticated user create answer for the question' do
    sign_in(user)

    visit question_path(question)

    fill_in id: 'answer_body', with: 'Test answer'
    click_on t('common.button.question.answer')

    expect(page).to have_content 'Test answer'
  end

  scenario 'Unauthenticated user tries create answer for the question' do
    visit question_path(question)

    fill_in id: 'answer_body', with: 'Test answer'
    click_on t('common.button.question.answer')

    expect(page).to have_content t('devise.failure.unauthenticated')
    expect(current_path).to eq new_user_session_path
  end
end