class ChangeActiveStorageRecordIdToUuid < ActiveRecord::Migration[7.2]
  def change
    change_column :active_storage_attachments, :record_id, :uuid
  end
end
