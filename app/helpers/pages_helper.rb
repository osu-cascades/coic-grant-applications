module PagesHelper

  def sum_award_amounts(applications)
    sum = 0
    applications.each do |app|
      if app.amount_approved != "n/a"
        sum += app.amount_approved.delete(",$").to_f
      end
    end

    return sum.round(2).to_s
  end

  def percentage_of_applicants(applications)
    all_applications = Application.all
    if applications.length > 0
      return ((applications.length().to_f / all_applications.length().to_f) * 100).round(2).to_s
    else
      return "0"
    end
  end

end