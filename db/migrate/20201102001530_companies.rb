class Companies < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :business_name, :string
    add_column :companies, :ein, :string
    add_column :companies, :bin, :string
    add_column :companies, :naics, :string
    add_column :companies, :zip, :string
    add_column :companies, :county, :string
    add_column :companies, :city, :string
    add_column :companies, :business_type, :string
    add_column :companies, :business_size, :string
    add_column :companies, :race, :string
    add_column :companies, :ethnicity, :string
    add_column :companies, :gender, :string
    add_column :companies, :percent_ownership, :string
    add_column :companies, :jobs_retained, :string
  end
end
