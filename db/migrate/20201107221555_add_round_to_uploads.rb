class AddRoundToUploads < ActiveRecord::Migration[5.2]
  def change
    add_column :uploads, :round, :string
  end
end
