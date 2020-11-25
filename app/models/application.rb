class Application < ApplicationRecord

  belongs_to :company

  def self.import(round_file, round_number)
    CSV.foreach(round_file.path, headers: true) do |row|
      a = Application.find_or_initialize_by(ein: row["Employer Identification Number (Federal EIN)"], round: round_number)
      a.business_name = row["Business Name"] || "n/a"
      a.bin = row["BIN"] || "n/a"
      a.zip = row["Zip Code"] || "n/a"
      a.county = row["County"] || "n/a"
      a.city = row["City"] || "n/a"
      a.naics = row["NAICS"] || "n/a"
      a.business_type = row["Business Type"] || "n/a"
      a.business_size = row["Number of Employees"] || "n/a"
      a.jobs_retained = row["Jobs Retained"] || "n/a"
      a.amount_approved = row["Total $ Approved:"] || "n/a"
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

    if attributes[:percent_ownership].present? 
      if !owner_query.empty?
        owner_query << " AND " + "CAST(owners.percent_ownership as INT) >= " + attributes[:percent_ownership]
      else
        owner_query << "CAST(owners.percent_ownership as INT) >= " + attributes[:percent_ownership]
      end
    end

    applications = Application.joins(company: :owners).where(owner_query)
    applications = filter_business_attributes(applications, attributes)
    return applications
  end

  def self.filter_business_attributes(applications, attributes)
    filtered_applications = []
    business_types = []
    business_types << "Sole Proprietorship" if attributes[:sole].present?
    business_types << "Partnership" if attributes[:prop_partnership].present?
    business_types << "Corporation" if attributes[:corporation].present?
    business_types << "LLC" if attributes[:llc].present?
    business_types << "501(c)3" if attributes[:c3].present?

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
      elsif attributes[:round].present? && app.round != attributes[:round]
        next
      elsif business_types.length() > 0 && !business_types.include?(app.business_type)
        next
      else
        filtered_applications << app unless filtered_applications.include?(app)
        
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
