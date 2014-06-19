class StaticPagesController < ApplicationController
  before_filter :authenticate_user!, only: [:authorize]

  def authorize
    @my_local_state = params[:state]
    @plan_id = params[:scope]
    @pre_token = params[:tok]
    @username = current_user.username
  end
end