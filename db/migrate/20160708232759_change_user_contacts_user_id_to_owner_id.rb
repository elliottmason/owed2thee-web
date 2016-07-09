class ChangeUserContactsUserIdToOwnerId < ActiveRecord::Migration
  def change
    rename_column :user_contacts, :user_id, :owner_id
  end
end
