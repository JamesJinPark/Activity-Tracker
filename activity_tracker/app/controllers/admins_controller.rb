class AdminsController < ApplicationController
	before_filter :authenticate_admin!

	def index
		@current_user = Admin.find(params[:format])
		#sign out all patients who might be logged in the same system
#		for patient in Patient.all
#			sign_out patient
#		end
	end
end
