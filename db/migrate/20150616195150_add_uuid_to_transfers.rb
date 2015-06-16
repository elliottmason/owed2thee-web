class AddUuidToTransfers < ActiveRecord::Migration
  def change
    add_column :transfers, :uuid, :uuid

    add_index :transfers, :uuid
  end
end
