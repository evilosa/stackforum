class AddIndexToBestAnswer < ActiveRecord::Migration[5.0]
  def change
    add_index :answers, [:question_id, :best]
  end
end
