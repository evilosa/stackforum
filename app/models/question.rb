class Question < ApplicationRecord
  has_many :answers
  has_many :attachments

  belongs_to :user

  validates :title, :body, :user_id, presence: true

  def best_answer!(params)
    self.transaction do
      self.answers.where(best: true).update_all(best: false)
      self.answers.where(id: params[:answer_id]).update(best: true)
    end
  end
end
