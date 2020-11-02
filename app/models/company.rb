class Company < ApplicationRecord

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      c = Company.new
      c.business_name = row["Business Name"]
      c.ein = row["EIN"]
      c.bin = row["BIN"]
      c.naics = row["NAICS"]
      c.zip = row["Zip"]
      c.county = 'default'
      c.city = row["City"]
      c.business_type = row["Business Type (select one)"]
      c.race = "race"
      c.ethnicity = "ethnicity"
      c.gender = "gender"
      c.percent_ownership = "percent ownership"
      c.jobs_retained = row["Jobs Retained"]
      c.save
    end
  end

end
