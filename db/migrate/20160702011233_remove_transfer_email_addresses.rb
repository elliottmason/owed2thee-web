class RemoveTransferEmailAddresses < ActiveRecord::Migration
  def change
    drop_table :transfer_email_addresses
  end
end
