class Post < ApplicationRecord
	belongs_to :user
	has_many :likes
	has_many :likers, through: :likes, source: :user

	validates :post_uuid, uniqueness: true
  before_validation :add_uuid

  private
    def add_uuid
      if post_uuid.nil?
        self.post_uuid = gen_uuid()
      end
    end

		def gen_uuid
			letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
			uuid = ""
			for idx in 1..10 
				uuid += letters[rand(52)]
			end
			return uuid
		end

end
