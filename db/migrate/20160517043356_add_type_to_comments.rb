class AddTypeToComments < ActiveRecord::Migration
  def change
    add_column :comments, :type, :string, index: true
  end
end
