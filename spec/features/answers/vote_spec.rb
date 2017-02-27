require_relative '../acceptance_helper'

feature 'Vote for answer', %q{
  In order to rates answers
  As an user
  I'd like to be able to vote
} do

  given!(:user_owner) { create(:user) }
  given!(:second_user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user_owner) }

  scenario 'Answer must have score' do
    visit question_path(question)
    expect(page.first('div#answer-score').text).to eq '0'
  end

  describe 'Authenticated user' do
    describe 'as answer owner' do
      before do
        login_as(user_owner, scope: :user, run_callbacks: false)
        visit question_path(question)
      end

      scenario 'can not vote', js: true do
        first('a#answer-upvote').click
        expect(first('div#answer-score')).to have_text('0', exact: true)
        first('a#answer-downvote').click
        expect(first('div#answer-score')).to have_text('0', exact: true)
      end
    end

    describe 'as not answer owner' do
      before do
        login_as(second_user, scope: :user, run_callbacks: false)
        visit question_path(question)
      end

      scenario 'can upvote just one time', js: true do
        first('a#answer-upvote').click
        expect(first('div#answer-score')).to have_text('1', exact: true)
        first('a#answer-upvote').click
        expect(first('div#answer-score')).to have_text('1', exact: true)
      end

      scenario 'can downvote just one time', js: true do
        first('a#answer-downvote').click
        expect(page.first('div#answer-score')).to have_text('-1', exact: true)
        first('a#answer-downvote').click
        expect(page.first('div#answer-score')).to have_text('-1', exact: true)
      end

      scenario 'can change vote', js: true do
        first('a#answer-downvote').click
        expect(page.first('div#answer-score')).to have_text('-1', exact: true)
        first('a#answer-upvote').click
        expect(page.first('div#answer-score')).to have_text('1', exact: true)
      end
    end
  end

  describe 'Not authenticated user' do
    before do
      visit question_path(question)
    end
    scenario 'redirect to sign in', js: true do
      first('a#answer-upvote').click
      expect(page).to have_current_path new_user_session_path
    end
  end
end