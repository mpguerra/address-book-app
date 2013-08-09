module Api
  class WebhooksController < ApplicationController

    def create
      # binding.pry
      doc = Nokogiri::XML(request.raw_post)
      action = doc.at_css('event//action')
      entity = doc.at_css('event//type')
      case action
      when "created"
        create_entity(entity, doc)
      when "udpated"
        update_entity(entity, doc)
      end
      render :nothing => true
    end

    private

    def create_entity(entity, xml)
      # binding.pry
      case entity
      when "user"
        new_user(xml)
      when "application"
        new_app(xml)
      end
    end

    def udpate_entity(entity, xml)
      case entity
      when "user"
        update_user(xml)
      when "application"
        update_app(xml)
      end
    end

    def new_app(xml)
      # binding.pry
      client_id = params[:client_id]
      client_secret = params[:client_secret]
      app_name = params[:app_name]

      @client_app = Opro::Oauth::ClientApp.create_with_user_and_name(current_user, client_app_name)
      @client_app.update_attribute(:app_id, client_id)
      @client_app.update_attribute(:app_secret, client_secret)
    end

    def update_app(xml)
    end

    def new_user(xml)
      # binding.pry
      @new_user = User.new(:name => params['name'], :email => params['email'], :password => params['password'], :password_confirmation => params['password'], :username => params['username'], :org_name => params['org_name'])
      @new_user.save
      sign_in @new_user
    end

    def udpate_user(xml)
    end
  end
end
