class RenameLoanParticipantsToTransferParticipants < ActiveRecord::Migration
  def change
    remove_index  :loan_participants,
                  name: 'index_loan_participants_on_loan_id_and_user_id'
    remove_index  :loan_participants,
                  name: 'index_loan_participants_on_loan_id'
    remove_index  :loan_participants,
                  name: 'index_loan_participants_on_user_id'

    rename_table  :loan_participants, :transfer_participants

    rename_column :transfer_participants, :loan_id, :participable_id
    add_column    :transfer_participants, :participable_type, :string,
                  null: false

    add_index     :transfer_participants,
                  [:participable_id, :participable_type, :user_id],
                  name: 'index_transfer_participants_participable_user_id',
                  unique: true
    add_index     :transfer_participants, [:participable_id, :participable_type],
                  name: 'index_transfer_participants_on_participable'
    add_index     :transfer_participants, :user_id
  end
end
