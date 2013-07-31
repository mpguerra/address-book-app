class ContactsController < ApplicationController
  before_filter :authenticate_user!
  allow_oauth!
  respond_to :html, :json

  # GET /contacts(.:format)
  def index
    @contacts = current_user.contacts.paginate(page: params[:page])
  end

  # GET /contact/:id(.:format)
  def show
  end

  # POST
  def create
    @contact = current_user.contacts.new(contact_params)
    if @contact.save
      flash[:success] = "Contact saved successfully!"
      redirect_to @contact
    else
      render 'new'
    end
  end

  def new
    @contact = Contact.new
  end
  
  def destroy
  end

  private 
    def contact_params
      params.require(:contact).permit(:name,:email,:phone)
    end
end