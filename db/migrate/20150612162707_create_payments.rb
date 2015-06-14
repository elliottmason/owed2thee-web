class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.belongs_to  :creator
      t.belongs_to  :payable, null: false, polymorphic: true
      t.belongs_to  :payer,   null: false
      t.monetize    :amount
      t.datetime    :paid_at
      t.string      :type
      t.timestamps            null: false

      t.index [:payable_id, :payable_type]
      t.index [:payer_id]
    end
  end
end
