class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!

  def home
    @companies = Company.all
    @applications = Application.all
    @owners = Owner.all
  end

  def browse; end

  def upload; end

  def company; end

end
