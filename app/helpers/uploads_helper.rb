module UploadsHelper

  def get_company(company_ein)
    Company.find_by(ein: company_ein)
  end
  
end
