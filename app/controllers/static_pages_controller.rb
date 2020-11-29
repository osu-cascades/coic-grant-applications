class StaticPagesController < ApplicationController

  def home
    @companies = Company.all
    @applications = Application.filter(params) || Application.all
    @owners = Owner.all
  end

  def new_query_params
  	params.require(:applications).permit(:jobs_retained, :business_name)
	end

  def browse; end

  def upload; end

  def company; end

end
