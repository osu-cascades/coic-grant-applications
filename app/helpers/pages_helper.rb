module PagesHelper

  def get_owner_names(owners)
    owner_names = ''
    owners.each do |o|
      owner_names += o.name + ", "
    end

    return owner_names
  end
  
end
