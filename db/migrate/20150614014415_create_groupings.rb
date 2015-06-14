class CreateGroupings < ActiveRecord::Migration
  def change
    create_table :groupings do |t|
      t.belongs_to :group,      index: true,  null: false
      t.belongs_to :groupable,  index: true,  null: false,  polymorphic: true
      t.timestamps null: false
    end
  end
end
