class RemoveTypeFromTransitions < ActiveRecord::Migration
  def change
    remove_column :transitions, :type 
  end
end
