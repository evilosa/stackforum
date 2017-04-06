class Vote < ApplicationRecord
  enum status: [:upvote, :downvote]

  validates :status, presence: true

  belongs_to :user
  belongs_to :votable, polymorphic: true, touch: true
end