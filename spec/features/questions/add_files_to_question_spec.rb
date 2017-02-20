require_relative '../acceptance_helper'

feature 'Add files to question', %q{

  In order to illustrate my question
  As an question's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }

  background do
    login_as(user, scope: :user, run_callbacks: false)
    visit new_question_path
  end

  scenario 'User adds file when asks question' do
    fill_in t('activerecord.attributes.question.title'), with: 'Test question'
    fill_in t('activerecord.attributes.question.body'), with: 'text text'

    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on t('common.button.create')

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end
end