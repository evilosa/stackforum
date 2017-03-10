class AddIdentitiesIndex < ActiveRecord::Migration[5.0]
  def change
    add_index :identities, [:provider, :uid]
  end
end
