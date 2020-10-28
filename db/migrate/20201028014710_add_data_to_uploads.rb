class AddDataToUploads < ActiveRecord::Migration[5.2]
  def change
    add_column :uploads, :data, :string
  end
end
