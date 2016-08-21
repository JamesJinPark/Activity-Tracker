Rails.application.routes.draw do

	devise_for :patients, :controllers => {registrations: "registrations", sessions: "sessions"}
	devise_for :admins, :controllers => {registrations: "registrations", sessions: "sessions"}

	resources :patients
	resources :admins

	root 'home#index'

	get "home" 						=>	"home/index"
	get "receive_tokens"			=> 	"patients#receive_tokens"
	get "patients/:id"	 			=> 	"patients#show"
	get "patients/sign_out" 		=>  "home/index"
	get "admin"						=>  "admin/index"
	get "patients/:id/authorize" 	=> 	"patients#authorize", as: :authorize
	get "patients/:id/activity" 	=> 	"patients#activity", as: :activity


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
