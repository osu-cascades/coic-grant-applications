class Application < ApplicationRecord

  belongs_to :company

  def self.import(round_file, round_number)
    CSV.foreach(round_file.path, headers: true) do |row|
      a = Application.new
      a.business_name = row["Business Name"]
      a.ein = row["EIN"]
      a.bin = row["BIN"]
      a.zip = row["Zip"]
      a.county = 'default'
      a.city = row["City"]
      a.naics = row["NAICS"]
      a.business_type = row["Business Type"]
      a.business_size = row["Number of Employees"]
      a.round = round_number
      a.jobs_retained = row["Jobs Retained"]
      a.amount_approved = row["Amount of Award"]
      company = Company.find_by(ein: a.ein)
      a.company_id = company.id
      a.save
    end
  end

  def self.filter(attributes)
    attributes.select {|k,v| v.present?}.reduce(all) do |scope, (key, value)|
      case key.to_sym
      when :business_name, :jobs_retained, :amount_approved, :ein, :bin, :naics, :zip, :county, :city, :business_size
        scope.where(key => value)
        
      when :american_indian, :asian, :native_hawaiian, :white, :other, :race_no_answer
        #scope.joins(:companies).joins(:owners).where(owners: {key => "White"})
        races = {
          :american_indian => "American Indian or Alaska Native",
          :asian => "Asian",
          :native_hawaiian => "Native Hawaiian or Pacific Islander",
          :white => "White",
          :other => "Other", 
          :race_no_answer => "Prefer not to answer"
        }
        
        scope.joins(company: :owners).where('owners.race' => races[key])
      else
        scope
      end
    end
  end

end
