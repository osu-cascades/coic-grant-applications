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
    ethnicity_query = create_ethnicity_query(attributes)
    gender_query = create_gender_query(attributes)
    owner_query = ""
    if !ethnicity_query.empty?
      owner_query << ethnicity_query
    end
    if !race_query.empty?
      if !owner_query.empty?
      owner_query << " AND " + race_query
      else
        owner_query << race_query
      end
    end
    if !gender_query.empty?
      if !owner_query.empty?
      owner_query << " AND " + gender_query
      else
        owner_query << gender_query
      end
    end
    puts(race_query)
    applications = Application.joins(company: :owners).where(owner_query)
    applications = filter_business_attributes(applications, attributes)
    return applications
  end

  def self.filter_business_attributes(applications, attributes)
    filtered_applications = []
    business_types = []
    if attributes[:sole].present?
      business_types << "Sole Proprietorship"
    end
    if attributes[:prop_partnership].present?
      business_types << "Partnership"
    end
    if attributes[:corporation].present?
      business_types << "Corporation"
    end
    if attributes[:llc].present?
      business_types << "LLC"
    end
    if attributes[:c3].present?
      business_types << "501(c)3"
    end

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
      elsif attributes[:business_size].present? && app.business_size != attributes[:business_size]
        next
      elsif business_types.length() > 0 && !business_types.include?(app.business_type)
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

  def self.create_ethnicity_query(attributes)
    ethnicity_query = ""

    ethnicities = {
      :non_hispanic_latino => "Non-Hispanic/Latino",
      :hispanic_latino => "Hispanic/Latino",
      :ethnicity_no_answer => "n/a",
    }

    ethnicities.each do |key, value|
      if attributes[key].present?
        if ethnicity_query.empty?
          ethnicity_query += "owners.ethnicity = " + "'" + value + "'"
        else
          ethnicity_query += " OR owners.ethnicity = " + "'" + value + "'"
        end
      end
    end
  
    return ethnicity_query
  end

  def self.create_gender_query(attributes)
    gender_query = ""

    genders = {
      :female => "Female",
      :male => "Male",
      :gender_no_answer => "prefer not to answer",
    }

    genders.each do |key, value|
      if attributes[key].present?
        if gender_query.empty?
          gender_query += "owners.gender = " + "'" + value + "'"
        else
          gender_query += " OR owners.gender = " + "'" + value + "'"
        end
      end
    end
  
    return gender_query
  end

end
