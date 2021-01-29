class Application < ApplicationRecord

  belongs_to :company

  def self.import(round_file, round_number)
    CSV.foreach(round_file.path, headers: true) do |row|
      a = Application.find_or_initialize_by(ein: row["Employer Identification Number (Federal EIN)"], round: round_number)
      a.business_name = row["Business Name"] || "n/a"
      a.bin = row["Business Identification Number (BIN issued by Oregon Employment Department)"] || "n/a"
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

  def self.filter(params)

    #return [] if params[:round].empty?

    ethnicities = {
      :non_hispanic_latino => "Non-Hispanic/Latino",
      :hispanic_latino => "Hispanic/Latino",
      :ethnicity_no_answer => "n/a",
    }
  
    genders = {
      :female => "Female",
      :male => "Male",
      :gender_no_answer => "Prefer not to answer",
    }
  
    races = {
      :american_indian => "American Indian or Alaska Native",
      :asian => "Asian",
      :native_hawaiian => "Native Hawaiian or Pacific Islander",
      :white => "White",
      :other => "Other", 
      :race_no_answer => "Prefer not to answer"
    }

    business_types = {
      :sole => "Sole Proprietorship",
      :prop_partnership => "Partnership",
      :corporation => "Corporation", 
      :llc => "LLC"
    }

    range_params = [:business_size, :jobs_retained]

    exact_match_params = [
      :city, 
      :business_name,
      :amount_approved,
      :ein,
      :bin,
      :naics,
      :zip,
      :county,
      :city,
      :round
    ]

    race_query = create_checkbox_query(params, races, "race", "owners")
    ethnicity_query = create_checkbox_query(params, ethnicities, "ethnicity", "owners")
    gender_query = create_checkbox_query(params, genders, "gender", "owners")
    business_type_query = create_checkbox_query(params, business_types, "business_type", "applications")
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

    if params[:percent_ownership].present? 
      if !owner_query.empty?
        owner_query << " AND " + "CAST(owners.percent_ownership as INT) >= " + params[:percent_ownership]
      else
        owner_query << "CAST(owners.percent_ownership as INT) >= " + params[:percent_ownership]
      end
    end

    application_query = self.create_application_query(params, exact_match_params)

    if !application_query.empty? && !business_type_query.empty?
      application_query = business_type_query + " AND " + application_query
    elsif !business_type_query.empty?
      application_query = business_type_query
    end


    applications = Application.joins(company: :owners).where(application_query).where(owner_query).distinct
    applications = filter_business_attributes(applications, params)
    return applications
  end

  def self.create_checkbox_query(params, category, attribute, table)
    query = ""

    category.each do |key, value|
      if params[key].present?
        if query.empty?
          query += table + "." + attribute + " = " + "'" + value + "'"
        else
          query += " OR " + table + "." + attribute + " = " + "'" + value + "'"
        end
      end
    end

    return query

  end

  def self.create_application_query(params, attributes)
    query = ""

    attributes.each do |a|
      value = params[a]

      if value.present?
        if query.empty?
          query += "applications." + a.to_s + " = " + "'" + value + "'"
        else
          query += " OR applications." + a.to_s + " = " + "'" + value + "'"
        end
      end

    end    

    return query
  end

  def self.filter_business_attributes(applications, attributes)
    filtered_applications = []
    applications.each do |app|
      if attributes[:jobs_retained].present? && app.jobs_retained[/^[^\-]+/].to_i < attributes[:jobs_retained].to_i
        next
      elsif attributes[:business_size].present? && !self.in_range(attributes[:business_size], app.business_size) 
        next
      else
        filtered_applications << app
      end
    end

    return filtered_applications
  end

  def self.in_range(query_range, business_range)
    query_range = query_range.split("-")
    query_min = query_range[0].to_i
    query_range[1] ? query_max = query_range[1].to_i : query_max = query_min
    
    biz_range = business_range.split("-")
    biz_min = biz_range[0].to_i
    biz_range[1] ? biz_max = biz_range[1].to_i : biz_max = biz_min

    return biz_min >= query_min && biz_max <= query_max  
  end

end
