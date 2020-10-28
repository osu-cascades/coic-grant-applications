class AddTitleToUploads < ActiveRecord::Migration[5.2]
  def change
    add_column :uploads, :title, :string
  end
end
