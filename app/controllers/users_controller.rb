class UsersController < ApplicationController
  before_action :restrict_unless_admin, only: [:index, :new, :create, :destroy]
  before_action :prevent_normal_users_from_editing_and_viewing_other_users, only: [:edit, :update, :show]
  before_action :ignore_password_and_password_confirmation, only: :update
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    safe_params = current_user.admin? ? user_params : user_params_without_role_or_active
    respond_to do |format|
      if @user.update(safe_params)
        sign_in(@user, :bypass => true) if @user == current_user
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def prevent_normal_users_from_editing_and_viewing_other_users
      redirect_to(root_url) unless current_user.id == params[:id].to_i || current_user.admin?
    end

    # https://github.com/plataformatec/devise/wiki/how-to:-manage-users-through-a-crud-interface
    def ignore_password_and_password_confirmation
      if params[:user][:password].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end
    end

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password,
        :password_confirmation, :role, :active)
    end

    def user_params_without_role_or_active
      user_params.except(:role, :active)
    end

end
