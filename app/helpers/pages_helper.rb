module PagesHelper

  def get_owner_race(owners)
    owner_races = ''
    owners.each do |o|
      owner_races += o.race + ", "
    end

    return owner_races
  end

	def get_owner_ethnicity(owners)
		owner_ethnicities = ''
		owners.each do |o|
			owner_ethnicities += o.ethnicity + ", "
		end

		return owner_ethnicities
	end
  
end
