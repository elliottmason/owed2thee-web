class CreateLoans < ActiveRecord::Migration
  def change
    create_table :loans do |t|
      t.belongs_to  :creator, index: true
      t.belongs_to  :group,   index: true
      t.belongs_to  :lender,  index: true, null: false
      t.monetize    :amount
      t.string      :description
      t.datetime    :confirmed_at
      t.timestamps null: false
    end
  end
end
