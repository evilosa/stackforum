class AddQuestionIdToAttachment < ActiveRecord::Migration[5.0]
  def change
    add_reference :attachments, :question
  end
end
