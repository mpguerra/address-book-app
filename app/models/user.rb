class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  has_many :contacts, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  #attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  validates_presence_of :name
  validates_uniqueness_of :name, :email, :case_sensitive => false
end
