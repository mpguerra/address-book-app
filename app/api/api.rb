require 'grape'
class API < Grape::API
	prefix 'api'
	version 'v1', :using => :path
	format :json

	mount Resources::Contacts
end
