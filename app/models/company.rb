class Company < ApplicationRecord

  def self.import(round_file)
    CSV.foreach(round_file.path, headers: true) do |row|
      c = Company.new
      c.business_name = row["Business Name"]
      c.ein = row["EIN"]
      c.bin = row["BIN"]
      c.naics = row["NAICS"]
      c.zip = row["Zip"]
      c.county = 'default'
      c.city = row["City"]
      c.business_type = row["Business Type"]
      c.business_size = row["Number of Employees"]
      c.save
    end
  end

end
