class SessionsController < Devise::SessionsController
	before_action :set_route

	private
	def set_route
		@route = request.path.split('/')[1]
	end
end
