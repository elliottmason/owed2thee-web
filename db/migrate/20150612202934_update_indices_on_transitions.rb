class UpdateIndicesOnTransitions < ActiveRecord::Migration
  def change
    remove_index :transitions,
                name: :index_confirmable_transitions_parent_most_recent
    remove_index :transitions,
                 name: :index_confirmable_transitions_parent_sort

    add_index :transitions,
              %i(transitional_id transitional_type type most_recent),
              name:   :index_transitions_parent_sort,
              unique: true
    add_index :transitions,
              %i(transitional_id transitional_type type sort_key),
              name:   :index_transitions_parent_most_recent,
              unique: true
  end
end
