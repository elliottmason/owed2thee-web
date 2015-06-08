class CreateConfirmableTransitions < ActiveRecord::Migration
  def change
    create_table :confirmable_transitions do |t|
      t.belongs_to  :confirmable, null: false, polymorphic: true
      t.string      :to_state,    null: false
      t.json        :metadata,    default: '{}'
      t.integer     :sort_key,    null: false
      t.boolean     :most_recent, null: false
      t.timestamps                null: false
    end

    add_index(:confirmable_transitions,
              [:confirmable_id, :confirmable_type, :sort_key],
              unique: true,
              name: 'index_confirmable_transitions_parent_sort')
    add_index(:confirmable_transitions,
              [:confirmable_id, :confirmable_type, :most_recent],
              unique: true,
              where: 'most_recent',
              name: 'index_confirmable_transitions_parent_most_recent')
  end
end
