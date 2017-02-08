class AddUserToAnswerAndQuestion < ActiveRecord::Migration[5.0]
  def change
    add_reference :questions, :user, index:true
    add_reference :answers, :user, index:true
  end
end
