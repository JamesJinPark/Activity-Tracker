Rails.application.routes.draw do

	devise_for :patients, :controllers => {:registrations => "registrations"}
	resources :patients

	root 'home#index'

	get "home" 				=>	"home/index"
	get "patients/:id" 		=> 	"patients#show"
	get "patients/sign_out" =>  "home/index"


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
