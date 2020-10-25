class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!

  def home; end

  def browse; end

  def upload; end

end
