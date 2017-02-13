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

    #save_screenshot('/home/dv1/development/stackforum/log/img0.png')

    within '.social-footer' do
      find('#edit-answer', match: :first).click
    end

    sleep 1

    page.execute_script("$('.wysihtml5-sandbox')[0].contentWindow.document.body.innerHTML='Test answer';")

    #save_screenshot('/home/dv1/development/stackforum/log/img2.png')

    page.find('#ready-button', match: :first).click()

    within '.social-footer' do
      expect(page).to have_content 'Test answer'
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