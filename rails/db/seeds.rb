# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create Roles
admin_role = Role.create(name: 'admin')

# Create User for Colin and Assign to Admin
user = User.create(first_name: 'Test', last_name: 'User', email: 'brewableapp@gmail.com', password: 'iLoveCoffee')
Assignment.create(user_id: user.id, role_id: admin_role.id)

Permission.create(role_id: admin_role.id, permission: 'users:get')

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