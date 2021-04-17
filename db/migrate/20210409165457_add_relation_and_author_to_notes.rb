class AddRelationAndAuthorToNotes < ActiveRecord::Migration[5.2]
  def change
    add_column :notes, :author, :string
    add_reference :notes, :company, foreign_key: true, null: false
  end
end
