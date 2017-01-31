class Answer < ApplicationRecord
  belongs_to :question

  validates :question_id, :body, presence: true
end
