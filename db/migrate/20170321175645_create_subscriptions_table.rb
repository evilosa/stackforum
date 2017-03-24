class CreateSubscriptionsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :subscriptions do |t|
      t.references :user
      t.integer :subscribable_id
      t.string :subscribable_type
      t.timestamps
    end

    add_index :subscriptions, [:subscribable_id, :subscribable_type, :user_id], name: 'index_subscription_search'
  end
end
