class Owner < ApplicationRecord

  has_and_belongs_to_many :companies, :uniq => true,  join_table: 'companies_owners'

  scope :asian, -> { where("race = 'Asian'") }
  scope :american_indian, -> { where("race = 'American Indian or Alaska Native'") }
  scope :native_hawaiian, -> { where("race = 'Native Hawaiian or Pacific Islander'") }
  scope :white, -> { where("race = 'White'") }
  scope :other, -> { where("race = 'Other'") }
  scope :race_no_answer, -> { where("race = 'Prefer not to answer'") }

  def self.import(demographic_file)
    CSV.foreach(demographic_file.path, headers: true) do |row|
        o = Owner.new
        o.ein = row["Employer Identification Number (Federal EIN)"] || "n/a"
        o.name = row["Name"] || "n/a"
        o.percent_ownership = row["% Ownership"] || "n/a"
        o.race = row["Race"] || "n/a"
        o.ethnicity = row["Ethnicity"] || "n/a"
        o.gender = row["Gender"] || "n/a"
        o.save

        companies = Company.where(ein: o.ein)
        companies.each do |c|
          c.owners << o
          # I'm not sure if this is needed, I'm getting duplicate
          #values when including it
          # o.companies << c
        end

      end
    end
end
