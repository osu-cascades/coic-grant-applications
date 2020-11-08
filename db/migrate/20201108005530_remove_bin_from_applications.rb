class RemoveBinFromApplications < ActiveRecord::Migration[5.2]
  def change
    remove_column :applications, :bin, :string
  end
end
