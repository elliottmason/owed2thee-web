class AddUuidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :uuid, :uuid, null: false

    add_index :users, :uuid, unique: true
  end
end
