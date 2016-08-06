class RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?


  def after_update_path_for(resource)
    patient_path(resource)
  end

  protected

  def configure_permitted_parameters
  	devise_parameter_sanitizer.permit(:account_update, keys: [:name, :dob, :mrn, :password, :password_confirmation, :current_password])
  end
end
