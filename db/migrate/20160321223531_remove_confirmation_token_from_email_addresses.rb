class RemoveConfirmationTokenFromEmailAddresses < ActiveRecord::Migration
  def change
    remove_column :email_addresses, :confirmation_token
    remove_column :email_addresses, :confirmation_sent_at
  end
end
