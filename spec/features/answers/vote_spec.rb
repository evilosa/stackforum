require_relative '../acceptance_helper'

feature 'Vote for answer', %q{
  In order to rate answers
  As an user
  I'd like to be able to vote
} do

  scenario 'Answer must have score'

  describe 'Authenticated user' do
    describe 'as answer owner' do
      scenario 'can not vote'
    end

    describe 'as not answer owner' do
      scenario 'can upvote just one time'
      scenario 'can downvote just one time'
      scenario 'can change vote'
    end
  end

  describe 'Not authenticated user' do
    scenario 'redirect to sign in'
  end
end