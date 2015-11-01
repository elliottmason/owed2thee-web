class CreateTransferEmailAddresses < ActiveRecord::Migration
  def change
    create_table :transfer_email_addresses do |t|
      t.references :email_address,  null: false
      t.references :transfer,       null: false
    end

    add_index :transfer_email_addresses, [:email_address_id, :transfer_id],
              name: 'index_transfer_email_addresses_on_foreign_keys'
  end
end
