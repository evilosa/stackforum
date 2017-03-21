require_relative '../acceptance_helper'

feature 'Create subscriptions for the question', %q{
  In order to subscribe for the question
  As an user
  I'd like to be able to create subscription
}, driver: :webkit do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user' do

    before do
      login_as(user, scope: :user, run_callbacks: false)
    end

    scenario 'sees subscribe link if unsubscribed' do
      visit question_path(question)
      expect(page).to have_css('#subscribe-question')
      expect(page).to_not have_css('#unsubscribe-question')
    end

    scenario 'sees unsubscribe link if subscribed' do
      question.subscribe!(user)
      visit question_path(question)
      expect(page).to_not have_css('#subscribe-question')
      expect(page).to have_css('#unsubscribe-question')
    end
  end

  describe 'Not authenticated user' do
    scenario 'not sees subscribe/unsubscribe link for the question' do
      expect(page).to_not have_css('#subscribe-question')
      expect(page).to_not have_css('#unsubscribe-question')
    end
  end
end
