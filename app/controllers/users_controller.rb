class UsersController < ApplicationController
	  before_filter :authenticate_user!

  def index
  end

  def show
  end

  private
 
    def user_params
      params.require(:user).permit(:name)
    end
end
