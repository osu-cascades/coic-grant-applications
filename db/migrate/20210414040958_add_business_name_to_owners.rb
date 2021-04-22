class AddBusinessNameToOwners < ActiveRecord::Migration[5.2]
  def change
    add_column :owners, :business_name, :string
  end
end
