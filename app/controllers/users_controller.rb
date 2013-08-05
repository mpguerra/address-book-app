class UsersController < ApplicationController
	before_filter :authenticate_user!, only: [:index, :edit, :update]
  allow_oauth! :except => :delete
  before_action :admin_user, only: :destroy

  $host = ENV['MY_ADMIN_PORTAL']

  def index
     @users = User.paginate(page: params[:page])
  end

  def show
    binding.pry
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

      # creates a user in the 3scale developer portal
    def threescale_signup
      payload = {}
      payload['username'] = CGI.escape(current_user.username)
      payload['provider_key'] = CGI.escape($provider_key)
      payload['org_name'] = CGI.escape(params['user']['org_name'])
      payload['email'] = CGI.escape(current_user.email)
      # compare hashes before storing/sending?
      payload['password'] = CGI.escape(params['user']['password'])

      uri = URI.parse("https://#{$host}/admin/api/signup.xml")
      http_response = Net::HTTP.post_form(uri, payload)
      doc = Nokogiri::XML(http_response.body)

      case http_response
      when Net::HTTPSuccess,Net::HTTPConflict
         # add org to db? 
        if doc.at_css('error')
          error_msg = doc.at_css('error').content
          render :text => error_msg
        else
          threescale_signin
        end
      when Net::HTTPClientError
        build_error_response(http_response.body)
      else
        raise ServerError.new(http_response)
      end
    end

    # signs in a user into the 3scale developer portal
    def threescale_signin
      payload = {}
      payload['username'] = CGI.escape(current_user.username)
      payload['provider_key'] = CGI.escape($provider_key)
      
      uri = URI.parse("https://#{$host}/admin/api/sso_tokens.xml")
      # request sso token
      http_response = Net::HTTP.post_form(uri, payload)
      doc = Nokogiri::XML(http_response.body)

      case http_response
      when Net::HTTPSuccess,Net::HTTPConflict
         # add org to db? 
        if doc.at_css('error')
          error_msg = doc.at_css('error').content
          render :text => error_msg
        else
          url = doc.at_css('sso_url').content
          redirect_to url and return
        end
      when Net::HTTPClientError
        build_error_response(http_response.body)
      else
        raise ServerError.new(http_response)
      end
    end

  private
  def user_params
    params.require(:user).permit(:name, :email, :username, :password, :password_confirmation, :admin)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
