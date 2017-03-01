module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :delete_all
    accepts_nested_attributes_for :votes, reject_if: :all_blank, allow_destroy: true
  end

  def upvote!(user)
    return if user.author_of?(self) || upvoted?(user)

    vote = votes.where(user: user).first_or_initialize
    vote.status = :upvote
    vote.save
  end

  def downvote!(user)
    return if user.author_of?(self) || downvoted?(user)

    vote = votes.where(user: user).first_or_initialize
    vote.status = :downvote
    vote.save
  end

  def upvoted?(user)
    votes.where(status: :upvote, user: user).present?
  end

  def downvoted?(user)
    votes.where(status: :downvote, user: user).present?
  end

  def score
    votes.where(status: :upvote).count - votes.where(status: :downvote).count
  end
end