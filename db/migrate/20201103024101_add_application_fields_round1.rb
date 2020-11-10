class AddApplicationFieldsRound1 < ActiveRecord::Migration[5.2]
  def change
  	add_column :companies, :street_address, :string
    add_column :companies, :amount_requested, :string
    add_column :companies, :number_of_employees, :string
  end
end
