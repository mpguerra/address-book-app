module Api
  class ContactsController < ApplicationController
    #before_filter :authenticate_user!
    before_filter :restrict_access
    respond_to :html, :json

    # GET /contacts(.:format)
    def index
      respond_to do |format|
        format.json do
          render :json => current_user.contacts.to_json
        end
      end
    end

    # GET /contact/:id(.:format)
    def show
      respond_to do |format|
        format.json do
          render :json => current_user.contacts.find(params[:id]).to_json
        end
      end
    end

    # POST
    def create
      name = "Get this from params"
      phone = 1234
      email = "Get_this@from_params"
      @contact = Contact.create(contact_params)

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

    protected
    def restrict_access
      puts request.host
      if request.host != 'address-book-app.herokuapp.com'
        redirect_to '/'
        flash.now[:notice] = "Access denied!"
        return false
      end
    end

    private
    def contact_params
      params.require(:contact).permit(:name,:email,:phone)
    end
  end
end