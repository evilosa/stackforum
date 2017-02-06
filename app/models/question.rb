class Question < ApplicationRecord
  has_many :answers
  belongs_to :user

  validates :title, :body, :user_id, presence: true
end
