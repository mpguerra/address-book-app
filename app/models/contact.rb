class Contact < ActiveRecord::Base
	belongs_to :user
	default_scope -> { order('name ASC')}
	validates :name, presence: true
	validates :user_id, presence: true
	attr_accessible :name, :email, :phone
end
