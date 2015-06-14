class CreateLoanPayments < ActiveRecord::Migration
  def change
    create_table :loan_payments do |t|
      t.belongs_to  :loan,    null: false
      t.belongs_to  :payment, null: false
      t.monetize    :amount
      t.timestamps            null: false
    end
  end
end
