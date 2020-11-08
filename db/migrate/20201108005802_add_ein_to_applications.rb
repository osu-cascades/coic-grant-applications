class AddEinToApplications < ActiveRecord::Migration[5.2]
  def change
    add_column :applications, :ein, :string
  end
end
