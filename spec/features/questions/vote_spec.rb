require_relative '../acceptance_helper'

feature 'Vote for question', %q{
  In order to rates questions
  As an user
  I'd like to be able to vote
} do

  given!(:user_owner) { create(:user) }
  given!(:second_user) { create(:user) }
  given!(:question) { create(:question, user: user_owner) }

  scenario 'Question must have score' do
    visit question_path(question)
    expect(page.first('div#question-score').text).to eq '0'
  end

  describe 'Authenticated user' do
    describe 'as question owner' do
      before do
        login_as(user_owner, scope: :user, run_callbacks: false)
        visit question_path(question)
      end

      scenario 'can not vote', js: true do
        first('a#question-upvote').click
        expect(page.first('div#question-score').text).to eq '0'
        first('a#question-downvote').click
        expect(page.first('div#question-score').text).to eq '0'
      end
    end

    describe 'as not question owner' do
      before do
        login_as(second_user, scope: :user, run_callbacks: false)
        visit question_path(question)
      end

      scenario 'can upvote just one time', js: true do
        first('a#question-upvote').click
        expect(first('div#question-score')).to have_text('1', exact: true)
        first('a#question-upvote').click
        expect(first('div#question-score')).to have_text('1', exact: true)
      end

      scenario 'can downvote just one time', js: true do
        first('a#question-downvote').click
        expect(page.first('div#question-score')).to have_text('-1', exact: true)
        first('a#question-downvote').click
        expect(page.first('div#question-score')).to have_text('-1', exact: true)
      end

      scenario 'can change vote', js: true do
        first('a#question-downvote').click
        expect(page.first('div#question-score')).to have_text('-1', exact: true)
        first('a#question-upvote').click
        expect(page.first('div#question-score')).to have_text('-1', exact: true)
      end
    end
  end

  describe 'Not authenticated user' do
    scenario 'redirect to sign in'
  end
end