require 'rubygems'
require 'withings'
include Withings
include Withings::Api

class PatientsController < ApplicationController
	before_action :authenticate_patient!, except: :index
	before_action :set_user, only: [:authorize, :show, :activity]

	def index
		redirect_to root_path
	end

	def authorize
		generate_authorization_url
	end

	def activity
		Withings.consumer_secret = WITHINGS_OAUTH_CONSUMER_SECRET
		Withings.consumer_key = WITHINGS_OAUTH_CONSUMER_KEY 

		user = User.authenticate(@current_user.withings_id, @current_user.withings_token_key, @current_user.withings_token_secret)
		
		@body = user.get_activities(:startdateymd => '2016-08-15', :enddateymd => '2016-08-21')
	end

	# GET /patients/1
	def show
	end

	def receive_tokens
		if patient_signed_in? 
			save_user_access_token
		end			
		redirect_to root_path
	end

	private

	WITHINGS_OAUTH_CONSUMER_KEY = "491fb39099b073d1170ebd8ce128497d7e2860e5efb7d1e9719fbc62f162e"
	WITHINGS_OAUTH_CONSUMER_SECRET = "9c5ff033f4f1b307f6e08977ee351242d8721f7b4ebd48c83fd0ed1d6b4d4c"
	
	# Creates a request token and URL that users can follow to allow Activity Tracker to access their data
	# Saves secret for request token's key to be used when creating access token	
	def generate_authorization_url
		consumer_token = ConsumerToken.new(WITHINGS_OAUTH_CONSUMER_KEY, WITHINGS_OAUTH_CONSUMER_SECRET)
		request_token_response = Withings::Api.create_request_token(consumer_token, "http://localhost:3000/receive_tokens")
		request_token = request_token_response.request_token
		current_patient.withings_request_token_secret = request_token.secret
		current_patient.save!
		@authorization_url = request_token_response.authorization_url
	end	

    # Use callbacks to share common setup or constraints between actions.
    # Called before specific activities that deals with specific patient's data(show, update, destroy, edit)
    # to set which patient's data to run the functionality with.
    def set_user
      @current_user = Patient.find(params[:id])
    end

    # Receives user id from Withings as well as authenticates request token to create access token
    # Access token is stored in patient data 
    def save_user_access_token
		current_patient.withings_id = params[:userid]
		consumer_token = ConsumerToken.new(WITHINGS_OAUTH_CONSUMER_KEY, WITHINGS_OAUTH_CONSUMER_SECRET)
		request_token = Withings::Api::RequestToken.new(params[:oauth_token], current_patient.withings_request_token_secret)
		access_token_response = Withings::Api.create_access_token(request_token, consumer_token, current_patient.withings_id)
		access_token = access_token_response.access_token
		current_patient.withings_token_key = access_token.key
		current_patient.withings_token_secret = access_token.secret
		current_patient.save!
	end 
end
