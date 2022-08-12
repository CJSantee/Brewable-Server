require 'rails_helper'

RSpec.describe User, :type => :model do 
	subject {
		User.new(
			first_name: "Colin",
			last_name: "Santee",
			email: "brewableapp@gmail.com",
			phone: "",
			password: "iLoveCoffee"
		)
	}
	it "is valid with valid attributes" do 
		expect(subject).to be_valid
	end
end