class RenameLoanBorrowersToLoanParticipants < ActiveRecord::Migration
  def change
    remove_index :loan_borrowers, column: [:borrower_id, :loan_id]

    rename_table :loan_borrowers, :loan_participants

    add_column :loan_participants, :type, :string
    rename_column :loan_participants, :borrower_id, :user_id

    add_index :loan_participants, [:loan_id, :user_id], unique: true
  end
end
