FactoryBot.define do 
	Faker::Config.locale = 'en-US'

	factory :user do 
		email { Faker::Internet.email }
		phone { Faker::PhoneNumber.cell_phone_in_e164 }
		first_name { Faker::Name.first_name }
		last_name { Faker::Name.last_name }
		password { Faker::Internet.password(min_length: 8, max_length: 10) }
	end
	factory :bean do
		name { Faker::Lorem.characters(number: 10) }
		roaster 
		origin
		flavor_notes
	end
	factory :bag do 
		bean { FactoryBot.build(:bean) }
		user { FactoryBot.build(:user) }
		roast_level
		roast_date
		price
		weight
		weight_unit
		rating
		photo_uri
		favorite
	end
end