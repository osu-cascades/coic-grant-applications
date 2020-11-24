class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!

  def home
    @companies = Company.all
    @applications = Application.filter(params) || Application.all
    #temporary solution to remove duplicates from results.
    @applications = Application.find(@applications.map(&:id).uniq)
    @owners = Owner.all
  end

  def new_query_params
  	params.require(:applications).permit(:jobs_retained, :business_name)
	end

  def browse; end

  def upload; end

  def company; end

end
