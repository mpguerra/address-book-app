class UsersController < ApplicationController
	before_filter :authenticate_user!
  allow_oauth! :except => :delete

  def index
  end

  def show
    @user = current_user if params[:id] == 'me'
    @user ||= User.find(params[:id])
    respond_to do |format|
      format.html
      format.json do
        render :json => @user.to_public_json
      end
    end
  end

  def update
    @user = current_user
    @user.update_attributes(user_params)
    respond_to do |format|
      format.json do
        render :json => @user.to_public_json
      end
      format.html do
        render :edit
      end
    end
  end

  def delete
    @user = current_user
    @user.destroy
    redirect_to root_path
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end
end
