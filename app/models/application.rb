class Application < ApplicationRecord

  def self.import(round_file, round_number)
    CSV.foreach(round_file.path, headers: true) do |row|
      a = Application.new
      a.business_name = row["Business Name"]
      a.ein = row["EIN"]
      a.bin = row["BIN"]
      a.zip = row["Zip"]
      a.county = 'default'
      a.city = row["City"]
      a.business_type = row["Business Type (select one)"]
      a.round = round_number
      a.jobs_retained = row["Jobs Retained"]
      a.amount_approved = row["Amount of Award"]
      a.save
    end
  end

  def self.filter(attributes)
    attributes.select {|k,v| v.present?}.reduce(all) do |scope, (key, value)|
      case key.to_sym
      when :business_name, :jobs_retained
        scope.where(key => value)
      else
        scope
      end
    end
  end
    
end
