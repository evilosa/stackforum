class Answer < ApplicationRecord
  has_many :attachments, as: :attachable

  belongs_to :question
  belongs_to :user

  validates :question_id, :body, :user_id, presence: true

  scope :ordered, -> { order('best desc, created_at') }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
end
