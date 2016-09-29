Rails.application.routes.draw do

	devise_for :patients, :controllers => {registrations: "registrations", sessions: "sessions"}
	devise_for :admins, :controllers => {registrations: "registrations", sessions: "sessions"}

	resources :patients
	resources :admins

	root 'home#index'
	get "home" 						=>	"home/index"
	get "withings_receive_tokens"	=> 	"patients#withings_receive_tokens"
	get "patients/:id"	 			=> 	"patients#show"
	get "patients/sign_out" 		=>  "home/index"
	get "admin"						=>  "admin/index"
	get "patients/:id/authorize" 	=> 	"patients#authorize", as: :authorize
	get "patients/:id/withings_activity" 	=> 	"patients#withings_activity", as: :withings_activity


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
