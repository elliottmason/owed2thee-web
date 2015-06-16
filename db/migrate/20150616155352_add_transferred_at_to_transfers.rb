class AddTransferredAtToTransfers < ActiveRecord::Migration
  def change
    add_column :transfers, :transferred_at, :datetime
  end
end
