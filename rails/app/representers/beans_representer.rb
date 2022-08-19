class BeansRepresenter
	def initialize(beans)
		@beans = beans
	end

	def as_json
		beans.map do |bean|
			{
				id: bean.id,
				name: bean.name,
				roaster: bean.roaster,
				origin: bean.origin,
				flavor_notes: bean.flavor_notes,
				photo_uri: bean.photo_uri,
			}
		end
	end

	private
	attr_reader :beans
end