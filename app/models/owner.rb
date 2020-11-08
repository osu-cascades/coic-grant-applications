class Owner < ApplicationRecord
  def self.import(demographic_file)
    CSV.foreach(demographic_file.path, headers: true) do |row|
        o = Owner.new
        o.bin = row["Business Identification Number (BIN issued by Oregon Employment Department)"] || "n/a"
        o.name = row["Name"] || "n/a"
        o.percent_ownership = row["% Ownership"] || "n/a"
        o.race = row["Race"] || "n/a"
        o.ethnicity = row["Ethnicity"] || "n/a"
        o.gender = row["Gender"] || "n/a"
        o.save
      end
    end
end
