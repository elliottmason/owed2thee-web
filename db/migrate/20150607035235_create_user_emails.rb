class CreateUserEmails < ActiveRecord::Migration
  def change
    create_table :user_emails do |t|
      t.belongs_to  :user,  null: false, index: true
      t.string      :email, null: false
      t.string      :confirmation_token
      t.datetime    :confirmation_sent_at
      t.datetime    :confirmed_at
      t.timestamps null: false

      t.index :email, unique: true
    end
  end
end
