module PagesHelper

  def get_owner(owner_ein)
    Owner.find_by(ein: owner_ein)
  end

  def get_company(company_ein)
    Company.find_by(ein: company_ein)
  end
end
