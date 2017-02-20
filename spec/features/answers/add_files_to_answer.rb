require_relative '../acceptance_helper'

feature 'Add files to answer', %q{

  In order to illustrate my answer
  As an authenticated user
  I'd like to be able to attach files
} do

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
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

    click_on t('common.button.ready')

    expect(current_path).to eq question_path(question)
    expect(page).not_to have_content t('common.button.ready')
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    within '.social-footer' do
      expect(page).to have_content 'Test answer'
    end
  end
end