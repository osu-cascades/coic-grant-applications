class CreateApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :applications do |t|
      t.string :bin, null: false
      t.string :round, null: false
      t.string :jobs_retained, null: false
      t.string :amount_approved, null: false
      t.timestamps
    end
  end
end
