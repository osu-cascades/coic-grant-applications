module PagesHelper

  def get_owner_race(owners)
    owner_races = ''
    owners.each do |o|
      owner_races += o.race + ", "
    end

    return owner_races
  end
  
end
