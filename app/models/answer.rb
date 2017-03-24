class Answer < ApplicationRecord
  include Attachable
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user

  after_create :notify_subscribers

  validates :question_id, :body, :user_id, presence: true

  scope :ordered, -> { order('best desc, created_at') }

  def notify_subscribers
    return if errors.any?

    SubscriptionJob.perform_later(self)
  end
end
