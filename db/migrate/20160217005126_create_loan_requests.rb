class CreateLoanRequests < ActiveRecord::Migration
  def change
    create_table :loan_requests do |t|
      t.belongs_to :creator, index: true, null: false
      t.money :amount_requested,              null: false
      t.money :amount_borrowed,   default: 0, null: false
      t.money :amount_repaid,     default: 0, null: false
      t.datetime :disbursement_deadline
      t.datetime :repayment_deadline
      t.timestamps null: false
    end
  end
end
