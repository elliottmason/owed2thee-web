class RemoveParticipableFromTransferParticipants < ActiveRecord::Migration
  def change
    rename_column :transfer_participants, :participable_id, :transfer_id
    remove_column :transfer_participants, :participable_type, :string

    add_index :transfer_participants, [:transfer_id, :user_id], unique: true
    add_index :transfer_participants, [:transfer_id]
  end
end
