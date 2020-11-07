class RemoveDemographicFromCompanies < ActiveRecord::Migration[5.2]
  def change
    remove_column :companies, :demographic_data, :string
  end
end
