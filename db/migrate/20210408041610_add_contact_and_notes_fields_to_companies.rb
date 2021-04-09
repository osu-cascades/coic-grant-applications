class AddContactAndNotesFieldsToCompanies < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :notes, :string
    add_column :companies, :phone, :string
    add_column :companies, :email, :string
  end
end
