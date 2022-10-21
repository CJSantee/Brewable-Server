require 'factory_bot_rails'
require 'date'

namespace :populate do 

	desc "Populate Sample Data" 
	task :sample => :environment do 
		users = FactoryBot.create_list(:user, 200)

		

	end

end