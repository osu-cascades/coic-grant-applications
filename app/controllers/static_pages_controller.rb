class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!

  def home
    @companies = Company.all

    @applications = Application.filter({
      :jobs_retained => params[:jobs_retained],
      :business_name => params[:business_name],
      :amount_approved => params[:amount_approved], 
      :ein => params[:ein],
      :bin => params[:bin], 
      :naics => params[:naics], 
      :zip => params[:zip],
      :county => params[:county], 
      :city => params[:city],
      :business_size => params[:business_size], 
      :asian => params[:asian], 
      :white => params[:white], 
      :american_indian => params[:american_indian], 
      :native_hawaiian => params[:native_hawaiian],
      :other => params[:other], 
      :race_no_answer => params[:race_no_answer],
      :non_hispanic_latino => params[:non_hispanic_latino],
      :hispanic_latino => params[:hispanic_latino],
      :ethnicity_no_answer => params[:ethnicity_no_answer]
    }) || Application.all
    
    @owners = Owner.all
  end

  def new_query_params
  	params.require(:applications).permit(:jobs_retained, :business_name)
	end

  def browse; end

  def upload; end

  def company; end

end
