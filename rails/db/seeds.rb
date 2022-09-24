# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(first_name: 'Colin', last_name: 'Santee', email: 'cjsantee2000@gmail.com', password: 'testpass')

Bean.create([
	{
		name: 'Geta Bore',
		roaster: 'Metric',
		origin: 'Ethiopia',
		flavor_notes: '["Jasmine","Lemon","Watermelon Candy"]',
		beans_uuid: SecureRandom.base64(10),
	},
	{
		name: 'Tana Luwu',
		roaster: 'Kwizera',
		origin: 'Indonesia',
		flavor_notes: '["Cherry Jam","Sweet Potato Pie"]',
		beans_uuid: SecureRandom.base64(10),
	},
	{
		name: 'Bella Vista',
		roaster: 'MáQuina Coffee Roasters',
		origin: 'Mexico',
		flavor_notes: '["Caramel","Creamy","Brown Sugar"]',
		beans_uuid: SecureRandom.base64(10),
	},
	{
		name: 'San Fernando',
		roaster: 'Wonderstate Coffee',
		origin: 'Peru',
		flavor_notes: '["Fudge","Citrus","Nougat"]',
		beans_uuid: SecureRandom.base64(10),
	}
])