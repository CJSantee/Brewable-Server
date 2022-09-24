require 'photos'

class BeansRepresenter
	def initialize(beans)
		@beans = beans
	end

	def as_json
		beans.map do |bean|
			{
				id: bean.id,
				beans_uuid: bean.beans_uuid,
				name: bean.name,
				roaster: bean.roaster,
				origin: bean.origin,
				flavor_notes: bean.flavor_notes,
				image: bean.image
			}
		end
	end

	private
	attr_reader :beans
end