require 'json'
require 'rubygems'
require 'withings'
require 'uri'
require 'net/http'
require 'net/https'

include Withings
include Withings::Api

class PatientsController < ApplicationController

	before_action :authenticate
	before_action :set_user, only: [:authorize, :show, :withings_activity, :moves_activity, :fitbit_activity,
		:destroy]

	def index
		redirect_to root_path
	end

	# GET /patients/1
	def show
	end

	def destroy
		@current_user.destroy
		flash[:notice] = "Patient removed"
   		redirect_to admins_path(current_admin)
   	end

	def authorize
		withings_generate_authorization_url
		moves_generate_authorization_url
		fitbit_generate_authorization_url
	end

	def withings_activity
		Withings.consumer_secret = WITHINGS_OAUTH_CONSUMER_SECRET
		Withings.consumer_key = WITHINGS_OAUTH_CONSUMER_KEY 

		user = User.authenticate(@current_user.withings_id, @current_user.withings_token_key, @current_user.withings_token_secret)
	   #@startdateymd = '2016-08-15'
		@startdateymd = Date.today.year.to_s + '-' + Date.today.to_s.split('-')[1] + '-' + '01'
		@enddateymd = Date.today.to_s
		if params[:startdateymd].present?
			@startdateymd = params[:startdateymd]
      	end
		if params[:enddateymd].present?
			@enddateymd = params[:enddateymd]
      	end

		response = user.get_activities(:startdateymd => @startdateymd, :enddateymd => @enddateymd)
		@unsorted_body = response["activities"]
		@body = @unsorted_body.sort_by{ |e| e["date"] }

		@weight = user.measurement_groups(measurement_type: 1)
		@height = user.measurement_groups(measurement_type: 4)
		@heart_rate = user.measurement_groups(measurement_type: 11)
	end

	def moves_activity
		@startdateymd = "20161001"
		@enddateymd = "20161012"

		if params[:startdateymd].present?
			@startdateymd = params[:startdateymd]
      	end
		if params[:enddateymd].present?
			@enddateymd = params[:enddateymd]
      	end

		uri = URI.parse("https://api.moves-app.com/api/1.1/user/summary/daily?from=" + @startdateymd + 
			"&to=" + @enddateymd + "&access_token=" + @current_user.moves_access_token)
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		request = Net::HTTP::Get.new(uri.request_uri)
		response = http.request(request)

		@body = response.body
		@parsed_data = JSON.parse(@body)
	end 

	def fitbit_activity

		def get_json(uri)
			http = Net::HTTP.new(uri.host, uri.port)
			http.use_ssl = true
			header_body = "Bearer " + @current_user.fitbit_access_token
			request = Net::HTTP::Get.new(uri.request_uri, 
				initheader = {"Authorization" => header_body})

			response = http.request(request)
			if response.code != '200'
				puts 'bad status code'
				puts response.code
				return false
			end
			return response
		end

		@startdateymd = "2016-09-01"
		@enddateymd = "2016-10-01"

		if params[:startdateymd].present?
			@startdateymd = params[:startdateymd]
      	end
		if params[:enddateymd].present?
			@enddateymd = params[:enddateymd]
      	end

		uri = URI.parse("https://api.fitbit.com/1/user/" + @current_user.fitbit_id + "/profile.json")
		response = get_json(uri)

		@user_body = response.body
		@parsed_user_data = JSON.parse(@user_body)
		
		# Get steps
		uri = URI.parse("https://api.fitbit.com/1/user/" + @current_user.fitbit_id + 
			"/activities/steps/date/"+ @startdateymd + "/" + @enddateymd +".json")

		response = get_json(uri)

		@step_body = response.body
		@parsed_step_data = JSON.parse(@step_body)
		
		# Get distance 
		uri = URI.parse("https://api.fitbit.com/1/user/" + @current_user.fitbit_id + 
			"/activities/distance/date/"+ @startdateymd + "/" + @enddateymd +".json")

		response = get_json(uri)

		@distance_body = response.body
		@parsed_distance_data = JSON.parse(@distance_body)

		# Get calories
		uri = URI.parse("https://api.fitbit.com/1/user/" + @current_user.fitbit_id + 
			"/activities/calories/date/"+ @startdateymd + "/" + @enddateymd +".json")

		response = get_json(uri)

		@calories_body = response.body
		@parsed_calories_data = JSON.parse(@calories_body)

		# Get heart
		uri = URI.parse("https://api.fitbit.com/1/user/" + @current_user.fitbit_id + 
			"/activities/heart/date/"+ @startdateymd + "/" + @enddateymd +".json")

		response = get_json(uri)

		@heart_body = response.body
		@parsed_heart_data = JSON.parse(@heart_body)

	end

	# Receives authorization code from Fitbit after user authorizes Activity Tracker
	def fitbit_receive_auth_code
		if patient_signed_in? 
			fitbit_save_user_access_token(params[:code])
		end
		redirect_to ("/patients/" + current_patient.id.to_s)
	end

	# Receives authorization code from Moves after user authorizes Activity Tracker 
	def moves_receive_auth_code
		if patient_signed_in? 
			moves_save_user_access_token(params[:code])
		end
		redirect_to ("/patients/" + current_patient.id.to_s)
	end

	def withings_receive_tokens
		if patient_signed_in? 
			withings_save_user_access_token
		end
		redirect_to ("/patients/" + current_patient.id.to_s)
	end


	private

    # Use callbacks to share common setup or constraints between actions.
    # Called before specific activities that deals with specific patient's data(show, update, destroy, edit)
    # to set which patient's data to run the functionality with.
    def set_user
      @current_user = Patient.find(params[:id])
    end

	def authenticate
	    if !admin_signed_in? then
        	authenticate_patient! except: :index
        else 
        	authenticate_admin!
      	end   
    end

    ############################## WITHINGS ##############################

	WITHINGS_OAUTH_CONSUMER_KEY = "491fb39099b073d1170ebd8ce128497d7e2860e5efb7d1e9719fbc62f162e"
	WITHINGS_OAUTH_CONSUMER_SECRET = "3ee48c7b35d7fe8163857f9930500d3361431de392779306df3d41bd662c8"
	
	# Creates a request token and URL that users can follow to allow Activity Tracker to access their data
	# Saves secret for request token's key to be used when creating access token	
	def withings_generate_authorization_url
		consumer_token = ConsumerToken.new(WITHINGS_OAUTH_CONSUMER_KEY, WITHINGS_OAUTH_CONSUMER_SECRET)
		request_token_response = Withings::Api.create_request_token(consumer_token, "http://localhost:3000/withings_receive_tokens")
		request_token = request_token_response.request_token

		#save request token secret in session data
		session[:request_token_secret] = request_token.secret

		@withings_authorization_url = request_token_response.authorization_url
	end	


    # Receives user id from Withings as well as authenticates request token to create access token
    # Access token is stored in patient data 
    def withings_save_user_access_token
		current_patient.withings_id = params[:userid]
		consumer_token = ConsumerToken.new(WITHINGS_OAUTH_CONSUMER_KEY, WITHINGS_OAUTH_CONSUMER_SECRET)
		request_token = Withings::Api::RequestToken.new(params[:oauth_token], session[:request_token_secret])

		access_token_response = Withings::Api.create_access_token(request_token, consumer_token, current_patient.withings_id)
		access_token = access_token_response.access_token

		current_patient.withings_token_key = access_token.key
		current_patient.withings_token_secret = access_token.secret
		current_patient.withings_authorized = true
		current_patient.save!
	end 



	############################## MOVES ##############################

	MOVES_CLIENT_ID = "WESAJw6iCmrUn2vj4vy9lcYgOPd22www"
	MOVES_CLIENT_SECRET = "1G3S3K236hn4cxQa24Dx1a9Jq9KInU9DKpUR84hEECdWC1iSNAw02DkQTJ72R03A"

	def moves_generate_authorization_url
		@moves_authorization_url = "https://api.moves-app.com/oauth/v1/authorize?response_type=code&client_id=" + 
		MOVES_CLIENT_ID + "&scope=activity"
	end


	# Uses authorization code to make a POST request and receive access token
    def moves_save_user_access_token(code)

    	# Make a POST request to get user access token from Moves
    	uri = URI.parse("https://api.moves-app.com")

    	http = Net::HTTP.new(uri.host, uri.port)
    	http.use_ssl = true
    	http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    	request = Net::HTTP::Post.new("https://api.moves-app.com/oauth/v1/access_token?grant_type=authorization_code&code=" +
    		code + "&client_id=" + MOVES_CLIENT_ID + "&client_secret=" + MOVES_CLIENT_SECRET)

    	response = http.request(request)
    	body = response.body

		current_patient.moves_id = JSON.parse(body)["user_id"]
		current_patient.moves_access_token = JSON.parse(body)["access_token"]
		current_patient.moves_refresh_token = JSON.parse(body)["refresh_token"]
		current_patient.moves_authorized = true
		current_patient.save!
	end 


    ############################## FITBIT ##############################
	
	FITBIT_CLIENT_ID = "22833K"
	FITBIT_CLIENT_SECRET = "c971cf8d0df2e469e17ec5b85e19856c"
	
	def fitbit_generate_authorization_url
		@fitbit_authorization_url = "https://www.fitbit.com/oauth2/authorize?response_type=code&client_id=" + 
		FITBIT_CLIENT_ID + "&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Ffitbit_receive_auth_code" + 
		"&scope=activity%20heartrate%20location%20nutrition%20profile%20settings%20sleep%20social%20weight&expires_in=604800"
	end

	def fitbit_save_user_access_token(code)

    	# Make a POST request to get user access token from Fitbit
    	uri = URI.parse("https://api.fitbit.com/oauth2/token")

    	http = Net::HTTP.new(uri.host, uri.port)
    	http.use_ssl = true
    	http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    	request = Net::HTTP::Post.new("https://api.fitbit.com/oauth2/token?grant_type=authorization_code&code=" +
    		code + "&client_id=" + FITBIT_CLIENT_ID + 
    		"&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Ffitbit_receive_auth_code", 
    		initheader = {"Authorization" => "Basic MjI4MzNLOmM5NzFjZjhkMGRmMmU0NjllMTdlYzViODVlMTk4NTZj", 
    			"Content-Type" => "application/x-www-form-urlencoded"})

    	response = http.request(request)
    	body = response.body
 
		current_patient.fitbit_id = JSON.parse(body)["user_id"]
		current_patient.fitbit_access_token = JSON.parse(body)["access_token"]
		current_patient.fitbit_refresh_token = JSON.parse(body)["refresh_token"]
		current_patient.fitbit_authorized = true
		current_patient.save!
	end




end
