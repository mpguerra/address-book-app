require '3scale_client'
class ApplicationController < ActionController::Base
  before_filter :configure_permitted_parameters, if: :devise_controller?
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  
  $client = ThreeScale::Client.new(:provider_key => ENV['MYAPI_PROVIDER_KEY'])

    def threescale_authenticate!
      $response = $client.oauth_authorize(:app_id => params[:client_id])
      $response.error!("403 Unauthorized : " + $response.error_message,  403) unless $response.success? && $response.app_key == params[:client_secret]
    end

    def report!(method_name='hits', usage_value=1)
      @app_id = params[:client_id]
      $response = $client.report( { :app_id => @app_id, :usage => { method_name => usage_value } } )
      $response.error!('505 Reporting Error', 505) unless $response.success?
    end

    protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_in) { |u| u.permit( :name, :email ) }
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit( :name, :email, :password, :password_confirmation ) }
      devise_parameter_sanitizer.for(:account_update) { |u| u.permit( :name, :email, :password, :password_confirmation, :current_password )}
    end
end
