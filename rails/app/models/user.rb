class User < ApplicationRecord
	has_secure_password 
	has_many :bags
	
	validates :email, uniqueness: true
	validates :phone, uniqueness: true, :allow_blank => true
end