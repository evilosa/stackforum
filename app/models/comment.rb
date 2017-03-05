class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true, optional: true

  validates :body, :commentable_id, :commentable_type, presence: true
end