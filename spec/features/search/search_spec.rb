require_relative '../acceptance_helper'
require_relative '../sphinx_helper'

# For this test works, you must:
#
# Install mysql2 libraries:
# sudo apt-get install libmysqlclient-dev
#
# run bundle
#
# Run postgresql console:
# sudo -u user_name psql db_name
#
# Set db user password:
# ALTER USER "user_name" WITH PASSWORD 'wY16DRcV';
#
# Set db user password to config/database.yml, example:
# password: wY16DRcV

# Before testing build indices for test searches, run:
# rake ts:index RAILS_ENV=test


feature 'Search', %q{
  In order to find question, answer, comment, user
  As an any user
  I want to be able to search these by text parts
}, driver: :poltergeist do

  given!(:question) { create(:question) }
  given!(:answer) { create(:answer) }
  given!(:user) { create(:user) }
  given!(:question_comment) { create(:comment, commentable: question) }
  given!(:answer_comment) { create(:comment, commentable: answer) }
  given!(:questions) { create_list(:question, 30, body: 'test body') }

  before do
    index
    visit root_path
  end

  scenario 'search question', sphinx: true do
    fill_in 'top-search', with: question.title
    page.execute_script("$('#search-form').submit()")

    expect(page).to have_content question.body
  end

  scenario 'search answer', sphinx: true
  scenario 'search comment for the question', sphinx: true
  scenario 'search comment for the answer', sphinx: true
  scenario 'search user', sphinx: true
  scenario 'search all', sphinx: true
  scenario 'search undefined data', sphinx: true
  scenario 'check pagination', sphinx: true
end