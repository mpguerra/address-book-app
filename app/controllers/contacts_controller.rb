class ContactsController < ApplicationController
  	allow_oauth!
	before_filter :authenticate_user!

  def index
  	@contacts = current_user.contacts

  	respond_to do |format|
  		format.json {render json: @contacts }
  	end 
  end

  def show
  	@contact = Contact.find(params[:id])

  	respond_to do |format|
  		format.json {render json: @contact}
  	end
  end

  def create
  end

  def destroy
  end
end