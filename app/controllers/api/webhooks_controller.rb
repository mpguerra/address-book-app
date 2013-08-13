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
      user_account_id = xml.at_css('event//object//application//user_account_id').content
      user = User.find_by developer_account_id: user_account_id
      binding.pry
      @client_app = Opro::Oauth::ClientApp.create_with_user_and_name(user, app_name)
      @client_app.update_attribute(:app_id, client_id)
      @client_app.update_attribute(:app_secret, client_secret)
    end

    def update_app(xml)
    end

    def new_user(xml)
      username = xml.at_css('event//object//user//username').content
      email = xml.at_css('event//object//user//email').content
      account_id = xml.at_css('event//object//user//account_id').content
      password = random_password
      @new_user = User.new(:name => username, :email => email, :password => password, :password_confirmation => password, :username => username)
      @new_user.update_attribute(:is_developer, true)
      @new_user.update_attribute(:developer_account_id, account_id)
      @new_user.save
    end

    def udpate_user(xml)
    end

    def random_password(size = 8)
      chars = (('a'..'z').to_a + ('0'..'9').to_a) - %w(i o 0 1 l 0)
      (1..size).collect{|a| chars[rand(chars.size)] }.join
    end

  end
end
