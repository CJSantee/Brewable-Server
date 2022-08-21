class User < ApplicationRecord
	has_secure_password 
	has_one_attached :avatar
	has_many :bags
	
	validates :email, uniqueness: true
	validates :phone, uniqueness: true, :allow_blank => true

	def avatar_url
    if avatar.attached?
      avatar.blob.url
    end
  end

end