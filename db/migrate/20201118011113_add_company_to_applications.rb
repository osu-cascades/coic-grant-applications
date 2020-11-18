class AddCompanyToApplications < ActiveRecord::Migration[5.2]
  def change
    add_reference :applications, :company, foreign_key: true, null: false
  end
end
