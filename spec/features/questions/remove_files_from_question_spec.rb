require_relative '../acceptance_helper'

feature 'Remove files from question', %q{

  In order to correct my question
  As an question's author
  I'd like to be able to remove files
} do

  use_selenium_driver

  given!(:file) { create(:attachment) }
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user, attachments: [file]) }

  describe 'Authenticated user' do

    describe 'as question''s owner' do
      background do
        login_as(user, scope: :user, run_callbacks: false)
        visit question_path(question)
      end

      scenario 'can see link ro remove file' do
        expect(page).to have_link('#remove-file')
      end

      scenario 'can remove file', js: true do
        find('#remove-file', match: :first).click()

        expect(page).not_to have_content file.file_name
      end
    end

    describe 'as not question''s owner' do
      let!(:second_user) { create(:user) }

      before do
        login_as(second_user, scope: :user, run_callbacks: false)
        visit question_path(question)
      end

      scenario 'can not see link to remove file' do
        expect(page).not_to have_link('#remove-file')
      end
    end

  end

  describe 'Not authenticated user' do
    scenario 'can not see link to remove file' do
      expect(page).not_to have_link('#remove-file')
    end
  end

end