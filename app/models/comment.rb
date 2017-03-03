class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true, optional: true

  TYPES = %w(Answer Question)

  validates :body, :commentable_id, :commentable_type, presence: true
  validates :commentable_type, inclusion: { in: TYPES}

  def self.types
    TYPES
  end
end