module PagesHelper

  def get_owner(owner_ein)
    Owner.find_by(ein: owner_ein)
  end
end
