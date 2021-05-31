class Company < ApplicationRecord
  has_many :applications
  has_many :notes, dependent: :destroy
  has_and_belongs_to_many :owners, :uniq => true, join_table: 'companies_owners'

  def self.import(round_file)
    CSV.foreach(round_file.path, headers: true) do |row|
      #c = Company.find_or_initialize_by(ein: row["Employer Identification Number (Federal EIN)"])
      if row["Business Name"] != nil
        c = Company.find_or_initialize_by(business_name: row["Business Name"].titleize)
        c.ein = row["Employer Identification Number (Federal EIN)"] || "n/a"
        c.bin = row["Business Identification Number (BIN issued by Oregon Employment Department)"] || "n/a"
        c.naics = row["NAICS"] || "n/a"
        c.zip = row["Zip Code"] || "n/a"
        c.county = row["County"] || "n/a"
        c.city = row["City"] || "n/a"
        c.business_type = row["Business Type"] || "n/a"
        c.phone = row["Telephone"] || "n/a"
        c.street_address = row["Street Address"] || "n/a"
        c.save
      end
    end
  end

  def self.search(search)
    if search
      search = search.titleize
      if Company.where('business_name LIKE ?', "%#{search}%") != nil
        Company.where('business_name LIKE ?', "%#{search}%")
      else
        Company.all
      end
    else
      Company.all
    end
  end

end
