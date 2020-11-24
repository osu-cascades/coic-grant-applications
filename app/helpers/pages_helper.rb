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

  def sum_award_amounts(applications)
    sum = 0
    applications.each do |app|
      if app.amount_approved != "n/a"
        sum += app.amount_approved.delete(",$").to_f
      end
    end

    return sum.round(2).to_s
  end
end