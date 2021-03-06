require_relative '../acceptance_helper'

feature 'View questions list', %q{
  In order to find community questions
  As an any user
  I want to be able to view all questions
} do

  given!(:questions) { create_list(:question_with_answers, 2) }

  background do
    visit questions_path
  end

  scenario 'Any user can see all questions' do
    #save_and_open_page
    expect(page).to have_content questions[0].title
    expect(page).to have_content questions[1].title
  end

  scenario 'Any user can see question and his answers' do
    click_on questions[0].title

    expect(page).to have_content questions[0].title
    expect(page).to have_content questions[0].body
    expect(page).to have_content questions[0].answers[0].body
    expect(page).to have_content questions[0].answers[1].body
  end

end