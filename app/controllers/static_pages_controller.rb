class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!

  def home
    @companies = Company.where(business_name: params[:business_name]) || Company.all
    @applications = Application.where(jobs_retained: params[:jobs_retained]) || Application.all
    @owners = Owner.all
  end

  def new_query_params
  	params.require(:applications).permit(:jobs_retained)
  	params.require(:company).permit(:business_name)
	end

  def browse; end

  def upload; end

  def company; end

end
