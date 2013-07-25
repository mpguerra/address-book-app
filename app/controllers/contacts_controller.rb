class ContactsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authenticate!
  allow_oauth!

  # GET /contacts(.:format)
  def index
  	respond_to do |format|
  		format.json do
  			if($response.success?)
                report!
  				render :json => current_user.contacts.to_json
  			else
  				render :json => $response.error_message.to_json
  			end
  		end
  	end 
  end

  # GET /contact/:id(.:format)
  def show
  	respond_to do |format|
  		format.json do
  			if($response.success?)
  				report!
  				render :json => current_user.contacts.find(params[:id]).to_json
  			else
  				render :json => $response.error_message.to_json
  			end
  		end
  	end 
  end

  # POST
  def create
  	name = "Get this from params"
  	phone = 1234
  	email = "Get_this@from_params"
  	@contact = Contact.create(:name => name, :phone => phone, :email => email)

  	respond_to do |format|
  		if @contact.save
  			format.json { render :json => { :name => name, :phone => phone, :email => email }  }
  		else
  			format.json { render :json => {:errors => @contact.errors.full_messages } }
  		end
  	end
  end

  # GET /api/contacts/:id/phone(.:format)
  def phone 
  	respond_to do |format|
  		format.html
  		format.json { render :json => current_user.contacts.find(params[:id]).phone.to_json }
  	end
  end

  def destroy
  end
end