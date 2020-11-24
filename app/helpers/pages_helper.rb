module PagesHelper

  def get_owner_attributes(owners, attr)
    owner_attributes = ''
    owners.each_with_index do |owner, index|
      owner_attributes += owner.send(attr)
      if index < owners.length() - 1
        owner_attributes += ", "
      end
    end

    return owner_attributes
  end
end