require 'rails_helper'
require 'sidekiq/testing'

Sidekiq::Testing.fake!

RSpec.describe SubscriptionJob, type: :job do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:user3) { create(:user) }
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }
  let!(:subscription_user1) { create(:subscription, subscribable: question, user: user1) }
  let!(:subscription_user2) { create(:subscription, subscribable: question, user: user2) }

  before do
    expect(SubscriptionMailer).to receive(:notify).with(user1, answer).and_call_original
    expect(SubscriptionMailer).to receive(:notify).with(user2, answer).and_call_original
  end

  it 'send notification for all subscribers' do
    SubscriptionJob.perform_now(answer)
  end

  it 'not send notification for unsubscribed user' do
    expect(SubscriptionMailer).to_not receive(:notify).with(user3, answer).and_call_original

    SubscriptionJob.perform_now(answer)
  end
end
