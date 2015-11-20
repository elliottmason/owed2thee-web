class CreateTemporarySignins < ActiveRecord::Migration
  def change
    create_table :temporary_signins do |t|
      t.references :email_address,  null: false
      t.references :user,           null: false
      t.string :confirmation_token, null: false
      t.string :type
      t.datetime :expires_at, null: false
      t.timestamps null: false
    end

    add_index :temporary_signins, :confirmation_token, unique: true
  end
end
