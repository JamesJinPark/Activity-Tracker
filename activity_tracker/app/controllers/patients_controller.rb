class PatientsController < ApplicationController

	# GET /patients/1
	def show
		@current_user = Patient.find(params[:id])
	end

end
