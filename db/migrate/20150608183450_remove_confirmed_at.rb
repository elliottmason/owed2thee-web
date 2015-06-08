class RemoveConfirmedAt < ActiveRecord::Migration
  def change
    remove_column :loan_participants, :confirmed_at
    remove_column :loans,             :confirmed_at
    remove_column :user_emails,       :confirmed_at
    remove_column :users,             :confirmed_at
  end
end
