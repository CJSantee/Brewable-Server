class Role < ApplicationRecord
	has_many :assignments
	has_many :users, through: :assignments
	has_many :permissions
end
