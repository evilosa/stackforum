class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.references :user
      t.integer :commentable_id
      t.string :commentable_type
      t.text :body

      t.timestamps
    end

    add_index :votes, [:votable_id, :votable_type, :user_id]

    add_index :comments, [:commentable_id, :commentable_type], name: 'index_commentable_search'
    add_index :comments, [:commentable_id, :commentable_type, :user_id], name: 'index_commentable_for_user'
  end
end
