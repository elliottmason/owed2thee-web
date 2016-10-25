class AddContactNameToTransfers < ActiveRecord::Migration
  def change
    add_column :transfers, :contact_name, :string
  end
end
