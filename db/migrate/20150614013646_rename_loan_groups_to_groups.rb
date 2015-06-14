class RenameLoanGroupsToGroups < ActiveRecord::Migration
  def change
    rename_table  :loan_groups, :groups

    add_column    :groups, :type, :string
  end
end
