class Resources::Contacts < Grape::API
	resource :contacts do
		get do
			current_user.contacts
		end
	end
end