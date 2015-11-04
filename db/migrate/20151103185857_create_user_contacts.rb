class CreateUserContacts < ActiveRecord::Migration
  def change
    create_table :user_contacts do |t|
      t.references :user,     null: false
      t.references :contact,  null: false
      t.references :source,   polymorphic: true

      t.timestamps null: false
    end

    add_index :user_contacts, [:contact_id, :user_id], unique: true
    add_index :user_contacts, [:source_id, :source_type]
  end
end
