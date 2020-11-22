module PagesHelper

  def get_owner_race(owners)
    owner_races = ''
    owners.each_with_index do |owner, index|
      owner_races += owner.race
      if index < owners.length() - 1
        owner_races += ", "
      end
    end

    return owner_races
  end

	def get_owner_ethnicity(owners)
		owner_ethnicities = ''
		owners.each_with_index do |owner, index|
      owner_ethnicities += owner.ethnicity
      if index < owners.length() - 1
        owner_ethnicities += ", "
      end
		end

		return owner_ethnicities
	end
  
	def get_owner_gender(owners)
		owner_genders = ''
		owners.each_with_index do |owner, index|
      owner_genders += owner.gender
      if index < owners.length() - 1
        owner_genders += ", "
      end
		end

		return owner_genders
	end
end
