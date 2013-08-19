class UsersController < ApplicationController
  before_filter :authenticate_user!, only: [:index, :edit, :update]
  allow_oauth! :except => :delete
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = current_user
    @contacts = current_user.contacts
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

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :username, :password, :password_confirmation, :admin)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
