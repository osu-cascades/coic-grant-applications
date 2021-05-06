class Owner < ApplicationRecord

  has_and_belongs_to_many :companies, :uniq => true,  join_table: 'companies_owners'

  scope :asian, -> { where("race = 'Asian'") }
  scope :american_indian, -> { where("race = 'American Indian or Alaska Native'") }
  scope :native_hawaiian, -> { where("race = 'Native Hawaiian or Pacific Islander'") }
  scope :white, -> { where("race = 'White'") }
  scope :other, -> { where("race = 'Other'") }
  scope :race_no_answer, -> { where("race = 'Prefer not to answer'") }

  def self.import(round_file)
    CSV.foreach(round_file.path, headers: true) do |row|
        max_owners = 3

        1.upto(max_owners) do |i|
          if row["Business Owner Name #{i}"] and !row["Business Owner Name #{i}"].strip.empty?
            o = Owner.find_or_initialize_by(business_name: row["Business Name"].titleize, name: row["Business Owner Name #{i}"])
            o.percent_ownership = row["% Ownership #{i}"] || "n/a"
            o.percent_ownership = "0" unless o.percent_ownership !~ /\D/
            o.business_name = row["Business Name"].titleize

            o.race = row["Race #{i}"] || "n/a"
            o.ethnicity = row["Ethnicity #{i}"] || "n/a"
            o.gender = row["Gender #{i}"] || "n/a"
            o.save

            companies = Company.where(business_name: o.business_name)
            companies.each do |c|
              c.owners << o unless c.owners.include?(o)
            end

          else
            if i > 1
              break
            end

            o = Owner.new(
              name: "n/a",
              percent_ownership: "n/a",
              race: "n/a",
              ethnicity: "n/a",
              gender: "n/a"
            )

            o.save
            companies = Company.where(business_name: row["Business Name"])
            companies.each do |c|
              c.owners << o unless c.owners.include?(o)
            end

          end
        end
    end
  end
end
