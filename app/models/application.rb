class Application < ApplicationRecord

  belongs_to :company

  def self.import(round_file, round_number)
    CSV.foreach(round_file.path, headers: true) do |row|
      #a = Application.find_or_initialize_by(ein: row["Employer Identification Number (Federal EIN)"], round: round_number)
      a = Application.find_or_initialize_by(business_name: row["Business Name"], round: round_number)
      a.ein = row["Employer Identification Number (Federal EIN)"] || "n/a"
      a.bin = row["Business Identification Number (BIN issued by Oregon Employment Department)"] || "n/a"
      a.zip = row["Zip Code"] || "n/a"
      a.county = row["County"] || "n/a"
      a.city = row["City"] || "n/a"
      a.naics = row["NAICS"] || "n/a"
      a.business_type = row["Business Type"] || "n/a"
      a.business_size = row["Number of Employees"] || "n/a"
      a.jobs_retained = row["Jobs Retained"] || "n/a"
      a.amount_approved = row["Total $ Approved:"] || "n/a"
      company = Company.find_by(business_name: a.business_name)
      a.company_id = company.id
      a.save
    end
  end

end
