feature 'Delete question', %q{
  In order to remove the question
  As an question owner
  I want to be able remove question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question_with_answers, user: user) }

  scenario 'Owner tries to remove question' do
    sign_in(user)

    visit question_path(question)

    first('#remove_question').click
    expect(page).to have_content t('common.messages.questions.destroy')
    expect(current_path).to eq questions_path
  end

  scenario 'Not question owner tries to remove question' do
    other_user = create(:user)
    sign_in(other_user)

    visit question_path(question)

    first('#remove_question').click
    expect(page).to have_content t('common.errors.not_allow')
  end

  scenario 'Unauthenticated user tries to remove question' do
    visit question_path(question)

    first('#remove_question').click
    expect(page).to have_content t('devise.failure.unauthenticated')
  end
end