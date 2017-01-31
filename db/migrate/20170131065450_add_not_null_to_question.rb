class AddNotNullToQuestion < ActiveRecord::Migration[5.0]
  def change
    change_column_null :questions, :title, false
    change_column_null :questions, :body, false
  end
end
