class RenameUserEmailsToEmailAddresses < ActiveRecord::Migration
  def change
    rename_column :user_emails, :email, :address
    rename_table :user_emails, :email_addresses
  end
end
