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
    race_query = create_race_query(attributes)
    puts(race_query)
    applications = Application.joins(company: :owners).where(race_query)
    applications = filter_business_attributes(applications, attributes)
    return applications
  end

  def self.filter_business_attributes(applications, attributes)
    filtered_applications = []

    applications.each do |app|
      if attributes[:city].present? && app.city != attributes[:city]
        next
      elsif attributes[:business_name].present? && app.business_name != attributes[:business_name]
        next
      elsif attributes[:jobs_retained].present? && app.jobs_retained != attributes[:jobs_retained]
        next
      elsif attributes[:amount_approved].present? && app.amount_approved != attributes[:amount_approved]
        next
      elsif attributes[:ein].present? && app.ein != attributes[:ein]
        next
      elsif attributes[:bin].present? && app.bin != attributes[:bin]
        next
      elsif attributes[:naics].present? && app.naics != attributes[:naics]
        next
      elsif attributes[:zip].present? && app.zip != attributes[:zip]
        next
      elsif attributes[:county].present? && app.county != attributes[:county]
        next
      elsif attributes[:city].present? && app.city != attributes[:city]
        next
      elsif attributes[:business_type].present? && app.business_type != attributes[:business_type]
        next
      elsif attributes[:business_size].present? && app.business_size != attributes[:business_size]
        next
      else
        filtered_applications << app
        
      end
    end

    return filtered_applications
  end

  def self.create_race_query(attributes)
    race_query = ""

    races = {
      :american_indian => "American Indian or Alaska Native",
      :asian => "Asian",
      :native_hawaiian => "Native Hawaiian or Pacific Islander",
      :white => "White",
      :other => "Other", 
      :race_no_answer => "Prefer not to answer"
    }

    races.each do |key, value|
      if attributes[key].present?
        if race_query.empty?
          race_query += "owners.race = " + "'" + value + "'"
        else
          race_query += " OR owners.race = " + "'" + value + "'"
        end
      end
    end
  
    return race_query
  end

end
