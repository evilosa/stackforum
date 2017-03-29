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

  given!(:question) { create(:question, body: '<p>question body test</p>') }
  given!(:answer) { create(:answer, body: '<p>answer body test</p>') }
  given!(:user) { create(:user, email: 'test@user.ru') }
  given!(:question_comment) { create(:comment, commentable: question, body: '<p>question comment body test</p>') }
  given!(:answer_comment) { create(:comment, commentable: answer, body: '<p>answer comment body test</p>') }
  given!(:questions) { create_list(:question, 10, body: '<p>question list test body</p>') }

  before do
    index
    visit search_path
  end

  scenario 'search question', sphinx: true do
    fill_in 'top-search', with: 'question'
    page.execute_script("$('#search-form').submit()")

    expect(page).to have_content 'question body test'
  end

  scenario 'search answer', sphinx: true do
    fill_in 'top-search', with: 'answer'
    page.execute_script("$('#search-form').submit()")

    expect(page).to have_content 'answer body test'
  end

  scenario 'search comment for the question', sphinx: true do
    fill_in 'top-search', with: 'question comment'
    page.execute_script("$('#search-form').submit()")

    expect(page).to have_content 'question comment body test'
  end

  scenario 'search comment for the answer', sphinx: true do
    fill_in 'top-search', with: 'answer comment'
    page.execute_script("$('#search-form').submit()")

    expect(page).to have_content 'answer comment body test'
  end

  scenario 'search user', sphinx: true do
    fill_in 'top-search', with: 'user.ru'
    page.execute_script("$('#search-form').submit()")

    expect(page).to have_content 'test@user.ru'
  end

  scenario 'search all', sphinx: true do
    fill_in 'top-search', with: 'test'
    page.execute_script("$('#search-form').submit()")

    expect(page).to have_content 'question body test'
    expect(page).to have_content 'answer body test'
  end

  scenario 'search undefined data', sphinx: true do
    fill_in 'top-search', with: 'InshtereGapatiti'
    page.execute_script("$('#search-form').submit()")

    expect(page).to have_content 'No matches'
  end

  scenario 'check pagination', sphinx: true do
    fill_in 'top-search', with: 'test'
    page.execute_script("$('#search-form').submit()")

    expect(page).to have_content 'Next Label'
  end
end