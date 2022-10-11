module TimeSince 
	ONE_MINUTE = 60
	ONE_HOUR = ONE_MINUTE * 60 
	ONE_DAY = ONE_HOUR * 24
	def time_since(time)
		diff = Time.now - time
		if diff < ONE_MINUTE
			"1m"
		elsif diff < ONE_HOUR 
			num_minutes = (diff / ONE_MINUTE).round()
			"#{num_minutes}m"
		elsif diff < ONE_DAY
			num_hours = (diff / ONE_HOUR).round()
			"#{num_hours}h"
		else
			time.strftime("%b %-d")
		end
	end
end	