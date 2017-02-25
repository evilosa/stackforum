require_relative '../acceptance_helper'

feature 'Remove files from question', %q{

  In order to correct my question
  As an question's author
  I'd like to be able to remove files
}, driver: :selenium do

  given!(:user) { create(:user) }
  given!(:file) { create(:attachment) }
  given!(:question) { create(:question, attachments: [file], user: user) }

  describe 'Authenticated user' do
    describe 'as question''s owner' do
      before do
        login_as(user, scope: :user, run_callbacks: false)
        visit question_path(question)
      end

      scenario 'can remove file', js: true do
        expect(page).to have_content 'test_file.dat'
        find('#remove-file', match: :first).click()
        expect(page).not_to have_content 'test_file.dat'
      end
    end

    describe 'as not question''s owner' do
      before do
        second_user = create(:user)
        login_as(second_user, scope: :user, run_callbacks: false)
        visit question_path(question)
      end

      scenario 'can not see link to remove file' do
        expect(page).not_to have_link('remove-file')
      end
    end

  end

  describe 'Not authenticated user' do
    scenario 'can not see link to remove file' do
      visit question_path(question)
      expect(page).not_to have_link('remove-file')
    end
  end

end