class CreateVotesTable < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|
      t.references :user
      t.integer :votable_id
      t.string :votable_type
      t.integer :status, default: 0
      t.timestamps
    end

    add_index :votes, [:votable_id, :votable_type, :status]
    add_index :votes, [:votable_type, :status, :user_id]
  end
end
