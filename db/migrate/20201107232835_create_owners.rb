class CreateOwners < ActiveRecord::Migration[5.2]
  def change
    create_table :owners do |t|
      t.string :bin, null: false
      t.string :name, null: false
      t.string :percent_ownership, null: false
      t.string :race, null: false
      t.string :ethnicity, null: false
      t.string :gender, null: false
      t.timestamps
    end
  end
end
