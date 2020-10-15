class RegistrationsController < Devise::RegistrationsController

  prepend_before_action :check_captcha, only: [:create]

  private

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email,
      :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email,
      :password, :password_confirmation, :current_password)
  end

  def check_captcha
    unless verify_recaptcha
      self.resource = User.new sign_up_params
      resource.validate
      respond_with_navigational(resource) { render :new }
    end
  end

end
