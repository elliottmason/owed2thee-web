class CreateLedgers < ActiveRecord::Migration
  def change
    create_table :ledgers do |t|
      t.belongs_to  :user_a,            null: false
      t.belongs_to  :user_b,            null: false
      t.monetize    :confirmed_balance
      t.monetize    :projected_balance
      t.timestamps                      null: false
      t.index [:user_a_id, :user_b_id], unique: true
    end
  end
end
