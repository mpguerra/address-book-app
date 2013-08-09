module Api
  class WebhooksController < ApplicationController

    def create

      doc = Nokogiri::XML(request.raw_post)
      action = doc.at_css('event//action').content
      entity = doc.at_css('event//type').content

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
      client_id = xml.at_css('event//object//application//application_id').content
      client_secret = xml.at_css('event//object//application//keys//key').content
      app_name = xml.at_css('event//object//application//name').content
      binding.pry
      # how do I know which user to create app for?
      @client_app = Opro::Oauth::ClientApp.create_with_user_and_name(current_user, app_name)
      @client_app.update_attribute(:app_id, client_id)
      @client_app.update_attribute(:app_secret, client_secret)
    end

    def update_app(xml)
    end

    def new_user(xml)
      username = xml.at_css('event//object//user//username').content
      email = xml.at_css('event//object//user//email').content
      account_id = xml.at_css('event//object//user//id').content
      # password = xml.at_css()
      # name = xml.at_css()
      # org_name = xml.at_css()
      binding.pry
      @new_user = User.new(:name => name, :email => email, :password => password, :password_confirmation => password, :username => username, :org_name => org_name)
      @new_user.save
      sign_in @new_user
    end

    def udpate_user(xml)
    end
  end
end
