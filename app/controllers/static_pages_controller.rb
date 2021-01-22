class StaticPagesController < ApplicationController

  def home
    @connection = ActiveRecord::Base.connection

    @companies = @connection.exec_query("SELECT * FROM companies")
    @applications = Application.filter(params) || @connection.exec_query("SELECT * FROM applications")
    @owners = @connection.exec_query("SELECT * FROM owners")
  end

  def new_query_params
  	params.require(:applications).permit(:jobs_retained, :business_name)
	end

  def browse; end

  def upload; end

  def company; end

end
