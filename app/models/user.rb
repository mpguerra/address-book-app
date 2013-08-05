class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  attr_accessible :name, :email, :username, :password, :password_confirmation, :remember_me, :admin
  
  has_many :contacts, dependent: :destroy
  validates_presence_of :name, :username
  validates_uniqueness_of :name, :username, :email, :case_sensitive => false

  def to_public_json(options = {})
  	to_public_hash.to_json
  end

  def to_public_hash(options = {})
    user_hash = self.attributes
    user_hash.delete('encrypted_password')
    user_hash.delete('last_sign_in_ip')
    user_hash.delete('current_sign_in_ip')
    user_hash.delete('reset_password_token')
    user_hash.delete('created_at')
    user_hash.delete('current_sign_in_at')
    user_hash.delete('remember_created_at')
    user_hash.delete('reset_password_sent_at')
    user_hash.delete('sign_in_count')
    user_hash.delete('admin')
    user_hash.delete('github_access_token')
    user_hash
  end
end
