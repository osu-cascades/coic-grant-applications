class AddEinToOwners < ActiveRecord::Migration[5.2]
  def change
    add_column :owners, :ein, :string
  end
end
