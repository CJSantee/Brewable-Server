class Post < ApplicationRecord
	belongs_to :user

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
				letter_idx = rand(52)
				letter = LETTERS[letter_idx]
				uuid += letter
			end
			return uuid
		end

end
