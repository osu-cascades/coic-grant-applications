class RemoveNoteFromCompany < ActiveRecord::Migration[5.2]
  def change
  	remove_column :companies, :notes, :string
  end
end
