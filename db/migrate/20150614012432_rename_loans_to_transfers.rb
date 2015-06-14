class RenameLoansToTransfers < ActiveRecord::Migration
  def change
    rename_table :loans, :transfers

    remove_column :transfers, :group_id

    add_reference :transfers, :sender,  index: true,
                                        null: false,
                                        polymorphic: true
    add_reference :transfers, :recipient, index: true,
                                          null: false,
                                          polymorphic: true
    add_column    :transfers, :type, :string, null: false
  end
end
