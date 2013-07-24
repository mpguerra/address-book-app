require '3scale_client'
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  $client = ThreeScale::Client.new(:provider_key => ENV["MYAPI_PROVIDER_KEY"])

    def authenticate!
      response = $client.oauth_authorize(:app_id => params[:app_id])
      response.error!('403 Unauthorized', 403) unless response.success? && response.app_key == params[:client_secret]
      return response
    end

    def report!(method_name='hits', usage_value=1)
      response = $client.report({:app_id => params[:app_id], :usage => {method_name => usage_value}})
      response.error!('505 Reporting Error', 505) unless response.success?
    end
end
