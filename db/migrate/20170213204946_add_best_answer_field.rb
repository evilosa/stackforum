class AddBestAnswerField < ActiveRecord::Migration[5.0]
  def change
    add_column :answers, :best, :boolean, index: true
  end
end
