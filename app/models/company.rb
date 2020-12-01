class Company < ApplicationRecord

  has_many :applications
  has_and_belongs_to_many :owners, :uniq => true, join_table: 'companies_owners'

  def self.import(round_file)
    CSV.foreach(round_file.path, headers: true) do |row|
      c = Company.find_or_initialize_by(ein: row["Employer Identification Number (Federal EIN)"])
      c.business_name = row["Business Name"] || "n/a"
      c.bin = row["Business Identification Number (BIN issued by Oregon Employment Department)"] || "n/a"
      c.naics = row["NAICS"] || "n/a"
      c.zip = row["Zip"] || "n/a"
      c.county = row["County"] || "n/a"
      c.city = row["City"] || "n/a"
      c.business_type = row["Business Type"] || "n/a"
      c.save
    end
  end

end
