class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :commentable,  null: false,  polymorphic: true
      t.references :commenter,    null: false,  polymoprhic: true
      t.text :body
      t.text :subject
      t.timestamps                null: false

      t.index %i(commentable_id commentable_type)
      t.index %i(commenter_id)
    end
  end
end
