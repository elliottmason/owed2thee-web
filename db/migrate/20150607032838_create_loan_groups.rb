class CreateLoanGroups < ActiveRecord::Migration
  def change
    create_table :loan_groups do |t|
      t.monetize  :projected_amount
      t.monetize  :confirmed_amount
      t.string    :description
      t.timestamps null: false
    end
  end
end
