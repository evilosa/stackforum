class Answer < ApplicationRecord
  include Attachable

  belongs_to :question
  belongs_to :user

  validates :question_id, :body, :user_id, presence: true

  scope :ordered, -> { order('best desc, created_at') }
end
