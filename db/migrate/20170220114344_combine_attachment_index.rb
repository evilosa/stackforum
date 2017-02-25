class CombineAttachmentIndex < ActiveRecord::Migration[5.0]
  def change
    remove_index :attachments, :attachable_id
    remove_index :attachments, :attachable_type
    add_index :attachments, [:attachable_id, :attachable_type]
  end
end
