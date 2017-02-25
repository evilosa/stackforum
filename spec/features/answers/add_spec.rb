require_relative '../acceptance_helper'

feature 'Add files to answer', %q{

  In order to illustrate my answer
  As an authenticated user
  I'd like to be able to attach files
}, driver: :selenium do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    login_as(user, scope: :user, run_callbacks: false)
    visit question_path(question)
  end

  scenario 'User adds file when asks question', js: true do
    click_on t('common.button.answer.add_new')

    sleep 1
    page.execute_script("$('.wysihtml5-sandbox')[0].contentWindow.document.body.innerHTML='Test answer';")

    page.attach_file 'answer_attachments_attributes_0_file', "#{Rails.root}/spec/support/test_file.dat", visible: false

    click_on t('common.button.ready')

    expect(current_path).to eq question_path(question)
    expect(page).not_to have_content t('common.button.ready')
    expect(page).to have_link 'test_file.dat'
    within '.social-footer' do
      expect(page).to have_content 'Test answer'
    end
  end
end