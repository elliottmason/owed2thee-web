class AddConfirmationTokenIndexToUserEmails < ActiveRecord::Migration
  def change
    add_index :user_emails, :confirmation_token, unique: true
  end
end
