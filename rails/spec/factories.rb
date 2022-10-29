FactoryBot.define do 
	Faker::Config.locale = 'en-US'

	factory :user do 
		username { Faker::Internet.unique.username(specifier: 5..12) }
		email { Faker::Internet.unique.email }
		phone { Faker::PhoneNumber.unique.cell_phone_in_e164 }
		name { Faker::Name.name }
		password { Faker::Internet.password(min_length: 8, max_length: 10) }
		bio { "I love #{Faker::Hobby.activity}!" }
	end

	factory :post do 
		user { FactoryBot.build(:user) }
		caption { Faker::Lorem.paragraph(sentence_count: 2) }
	end

	factory :like do 
		post { FactoryBot.build(:post) }
		user { FactoryBot.build(:user) }
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