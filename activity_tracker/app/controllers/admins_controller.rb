class AdminsController < ApplicationController
	before_action :authenticate_admin!

	def index
		@current_user = Admin.find(params[:format])
		#sign out all patients who might be logged in the same system
	end
end
