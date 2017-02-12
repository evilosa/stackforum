require_relative '../acceptance_helper'

feature 'Edit answer', %q{
  In order to fix mistake
  As an author
  I want to be able edit answer
} do

  given!(:user) { create(:user) }
  given(:second_user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Unauthenticated user not sees edit link for answers', js: true do
    create(:answer, question: question, user: user)
    create(:answer, question: question, user: second_user)

    visit question_path(question)

    within '.social-footer' do
      expect(page).to_not have_content t('common.button.edit')
    end
  end

  scenario 'can edit his answer', js: true do
    create(:answer, question: question, user: user)

    login_as(user, scope: :user, run_callbacks: false)

    visit question_path(question)

    within '.social-footer' do
      click_on t('common.button.edit')
    end

    within_frame 0 do
      find('.bootsy_text_area', match: :first).set('Test answer')
    end
    click_on t('common.button.ready')

    using_wait_time 10 do
      within '.social-footer' do
        expect(page).to have_content 'Test answer'
      end
    end
    expect(current_path).to eq question_path(question)
    expect(page).not_to have_content t('common.button.ready')

  end

  scenario 'sees link to edit answer', js: true do
    create(:answer, question: question, user: user)
    login_as(user, scope: :user)

    visit question_path(question)

    within '.social-footer' do
      expect(page).to have_content t('common.button.edit')
    end
  end

  scenario 'not sees link to edit', js: true do
    create(:answer, question: question, user: second_user)

    login_as(user, scope: :user)

    visit question_path(question)

    within '.social-footer' do
      expect(page).to_not have_content t('common.button.edit')
    end
  end
end