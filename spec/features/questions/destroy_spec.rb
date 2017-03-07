require_relative '../acceptance_helper'

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

    within '.social-action' do
      first('#remove-question').click
    end

    expect(page).to have_content t('flash.actions.destroy.notice', resource_name: t('activerecord.models.question.one'))
    expect(current_path).to eq questions_path
    expect(page).not_to have_content question.title
  end

  scenario 'Not question owner not sees delete link' do
    other_user = create(:user)
    sign_in(other_user)

    visit question_path(question)

    within '.social-action' do
      expect(page).not_to have_content t('common.button.delete')
    end
  end

  scenario 'Unauthenticated user not sees delete link' do
    visit question_path(question)

    within '.social-action' do
      expect(page).not_to have_content t('common.button.delete')
    end
  end
end