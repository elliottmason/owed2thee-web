class RemoveLenderIdFromLoans < ActiveRecord::Migration
  def change
    remove_column :loans, :lender_id
  end
end
