class RemoveColoumnsFromCompanies < ActiveRecord::Migration[5.2]
  def change
    remove_column :companies, :round, :string
    remove_column :companies, :jobs_retained, :string
    remove_column :companies, :percent_ownership, :string
    remove_column :companies, :gender, :string
    remove_column :companies, :ethnicity, :string
    remove_column :companies, :race, :string
  end
end
