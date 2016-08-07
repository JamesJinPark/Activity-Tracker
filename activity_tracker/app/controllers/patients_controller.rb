class PatientsController < ApplicationController
	before_action :authenticate_patient!

	# GET /patients/1
	def show
		@current_user = Patient.find(params[:id])
	end

end
