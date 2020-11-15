class AddBusinessFieldsToApplication < ActiveRecord::Migration[5.2]
  def change
    add_column :applications, :business_name, :string
    add_column :applications, :bin, :string
    add_column :applications, :naics, :string
    add_column :applications, :zip, :string
    add_column :applications, :county, :string
    add_column :applications, :city, :string
    add_column :applications, :business_type, :string
    add_column :applications, :business_size, :string
  end
end
