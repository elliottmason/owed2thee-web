class AddDisplayNameToUserContacts < ActiveRecord::Migration
  def change
    add_column :user_contacts, :fallback_display_name,  :string
    add_column :user_contacts, :display_name,           :string
  end
end
