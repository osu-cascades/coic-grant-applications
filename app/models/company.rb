class Company < ApplicationRecord

  has_many :applications

  def self.import(round_file)
    CSV.foreach(round_file.path, headers: true) do |row|
      c = Company.find_or_initialize_by(ein: row["EIN"])
      c.business_name = row["Business Name"]
      c.bin = row["BIN"]
      c.naics = row["NAICS"]
      c.zip = row["Zip"]
      c.county = 'default'
      c.city = row["City"]
      c.business_type = row["Business Type (select one)"]
      c.save
    end
  end

end
