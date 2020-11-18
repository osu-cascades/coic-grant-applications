class CreateJoinTableCompanyOwners < ActiveRecord::Migration[5.2]
  def change
    create_join_table :companies, :owners do |t|
      t.index [:company_id, :owner_id]
      t.index [:owner_id, :company_id]
    end
  end
end
