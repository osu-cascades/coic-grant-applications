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

    race_query = create_query(params, races, "race")
    ethnicity_query = create_query(params, ethnicities, "ethnicity")
    gender_query = create_query(params, genders, "gender")
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

    applications = Application.joins(company: :owners).where(owner_query)
    applications = filter_business_attributes(applications, params)
    return applications
  end

  def self.create_query(params, category, attribute)
    query = ""

    category.each do |key, value|
      if params[key].present?
        if query.empty?
          query += "owners." + attribute + " = " + "'" + value + "'"
        else
          query += " OR owners." + attribute + " = " + "'" + value + "'"
        end
      end
    end

    return query

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
      elsif attributes[:jobs_retained].present? && app.jobs_retained[/^[^\-]+/].to_i < attributes[:jobs_retained].to_i
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
      elsif attributes[:business_size].present? && !self.in_range(attributes[:business_size], app.business_size) 
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
