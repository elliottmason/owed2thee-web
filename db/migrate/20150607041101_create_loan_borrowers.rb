class CreateLoanBorrowers < ActiveRecord::Migration
  def change
    create_table :loan_borrowers do |t|
      t.belongs_to  :borrower,  index: true,  null: false
      t.belongs_to  :loan,      index: true,  null: false
      t.datetime    :confirmed_at
      t.timestamps null: false

      t.index [:borrower_id, :loan_id], unique: true
    end
  end
end
