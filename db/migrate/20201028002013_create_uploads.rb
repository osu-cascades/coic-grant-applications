class CreateUploads < ActiveRecord::Migration[5.2]
  def change
    create_table :uploads do |t|

      t.timestamps
      t.string :title
      t.references :user
      t.string :ein
      t.string :bin
      t.string :data

    end
  end
end
