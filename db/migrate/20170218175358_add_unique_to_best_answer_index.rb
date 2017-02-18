class AddUniqueToBestAnswerIndex < ActiveRecord::Migration[5.0]
  def up
    remove_index :answers, [ :question_id, :best]
    add_index :answers, [:question_id, :best], unique: true, where: :best
  end

  def down
    remove_index :answers, [ :question_id, :best]
    add_index :answers, [:question_id, :best]
  end
end
