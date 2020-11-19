module PagesHelper

  def get_owner_names(owners)
    owner_names = ''
    owners.each do |o|
      owner_names += o.race + ", "
    end

    return owner_names
  end
  
end
