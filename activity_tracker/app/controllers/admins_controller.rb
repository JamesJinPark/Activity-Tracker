class AdminsController < ApplicationController
	before_action :authenticate_admin!

	def index
		@current_user = Admin.find(params[:format])
	end
end
