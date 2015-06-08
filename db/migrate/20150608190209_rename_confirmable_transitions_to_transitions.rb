class RenameConfirmableTransitionsToTransitions < ActiveRecord::Migration
  def change
    rename_table :confirmable_transitions, :transitions

    add_column :transitions, :type, :string
    rename_column :transitions, :confirmable_id,    :transitional_id
    rename_column :transitions, :confirmable_type,  :transitional_type
  end
end
