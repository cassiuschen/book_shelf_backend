module ApplicationHelper
	def humanize_time(time)
		DateTime.parse(time.to_s).strftime('%Y年%m月%d日')
	end
end
