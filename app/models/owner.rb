class Owner < ApplicationRecord
  def self.import(demographic_file)
    CSV.foreach(round_file.path, headers: true) do |row|
        o = Owner.new
        o.bin = row["BIN"]
        o.name = row["Name"]
        o.percent_ownership = row["% Ownership"]
        o.race = row["Race"]
        o.ethnicity = row["Ethnicity"]
        o.gender = row["Gender"]
        o.save
      end
    end
end
