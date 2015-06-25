class AddUuidToTransfers < ActiveRecord::Migration
  def change
    add_column :transfers, :uuid, :uuid, null: false

    add_index :transfers, :uuid, unique: true
  end
end
