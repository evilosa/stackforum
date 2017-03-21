module Subscribable
  extend ActiveSupport::Concern

  included do
    has_many :subscriptions, as: :subscribable, dependent: :delete_all
  end

  def subscribe!(user)
    subscription = subscriptions.where(user: user).first_or_initialize
    subscription.save
  end

  def unsubscribe!(user)
    subscription = subscriptions.where(user: user).first
    subscription.destroy if subscription
  end
end