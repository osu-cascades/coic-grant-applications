class AddRoundToCompanies < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :round, :string
  end
end
