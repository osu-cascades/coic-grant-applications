class RemoveBinFromOwner < ActiveRecord::Migration[5.2]
  def change
    remove_column :owners, :bin, :string
  end
end
