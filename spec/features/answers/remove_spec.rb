require_relative '../acceptance_helper'

feature 'Remove files from question', %q{

  In order to correct my question
  As an question's author
  I'd like to be able to remove files
} do

  given!(:user) { create(:user) }
  given!(:file) { create(:attachment) }
  given!(:question) { create(:question, attachments: [file], user: user) }
  given!(:answer) { create(:answer, question: question, attachments: [file], user: user) }

  describe 'Authenticated user' do
    describe 'as question''s owner' do
      before do
        login_as(user, scope: :user, run_callbacks: false)
        visit question_path(question)
      end

      scenario 'can remove file', js: true do
        expect(page).to have_link 'test_file.dat'
        within '#answer-files-body' do
          first('#remove-file').click()
          expect(page).not_to have_link 'test_file.dat'
        end
      end
    end

    describe 'as not question''s owner' do
      before do
        second_user = create(:user)
        login_as(second_user, scope: :user, run_callbacks: false)
        visit question_path(question)
      end

      scenario 'can not see link to remove file' do
        within '#answer-files-body' do
          expect(page).not_to have_link('#remove-answer-file')
        end
      end
    end

  end

  describe 'Not authenticated user' do
    scenario 'can not see link to remove file' do
      visit question_path(question)
      expect(page).not_to have_link('#remove-answer-file')
    end
  end

end