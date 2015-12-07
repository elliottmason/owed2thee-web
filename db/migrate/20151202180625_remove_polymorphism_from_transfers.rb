class RemovePolymorphismFromTransfers < ActiveRecord::Migration
  def change
    remove_column :transfers, :recipient_type
    remove_column :transfers, :sender_type
  end
end
