feature 'Delete answer for question', %q{
  In order to remove bad answer for the question
  As an answer owner
  I want to be able remove answer
} do

  given!(:user) { create(:user) }
  given(:question) { create(:question_with_owner_answers, user: user) }

  scenario 'Owner tries to remove the answer' do
    sign_in(user)
    visit question_path(question)

    first('#remove_answer').click
    expect(page).to have_content t('common.messages.answers.destroy')
    expect(current_path).to eq question_path(question)
  end

  scenario 'Not answer owner tries to remove the answer' do
    other_user = create(:user)
    sign_in(other_user)

    visit question_path(question)

    first('#remove_answer').click

    expect(page).to have_content t('common.errors.not_allow')
  end

  scenario 'Unauthenticated user tries to remove the answer' do
    visit question_path(question)

    first('#remove_answer').click
    expect(page).to have_content t('devise.failure.unauthenticated')
  end
end