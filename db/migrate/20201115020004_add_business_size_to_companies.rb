class AddBusinessSizeToCompanies < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :business_size, :string
  end
end
