class ApplicationController < ActionController::Base
  before_filter :configure_permitted_parameters, if: :devise_controller?
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit( :name, :email, :username ) }
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit( :name, :email, :username, :password, :password_confirmation ) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit( :name, :email, :username, :password, :password_confirmation, :current_password )}
  end
end
