require 'rails_helper'

RSpec.describe User, :type => :model do 
	subject {
		User.new(
			name: "First Last",
			email: "thisisanemail@gmail.com",
			phone: "",
			password: "iLoveCoffee"
		)
	}
	it "is valid with valid attributes" do 
		expect(subject).to be_valid
	end
end