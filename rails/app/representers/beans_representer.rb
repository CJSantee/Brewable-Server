require 'photos'

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
				image: {
					data: Base64.encode64(get_photo(bean.photo_uri).read),
					content_type: 'image/webp',
				},
			}
		end
	end

	private
	attr_reader :beans
end