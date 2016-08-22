class RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_out_path_for(resource)
  	root_path
  end

  def after_update_path_for(resource)
    flash[:notice] = "Successfully updated your profile"
  	if patient_signed_in?
      patient_path(resource)
    elsif admin_signed_in? 
      admins_path(resource)
    else 
      root_path
    end
  end

  protected

  def configure_permitted_parameters
  	devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :dob, :mrn, :password, :password_confirmation, :remember_me])
  	devise_parameter_sanitizer.permit(:sign_in, keys: [:login, :email, :mrn, :password, :remember_me])
  	devise_parameter_sanitizer.permit(:account_update, keys: [:name, :dob, :mrn, :password, :password_confirmation, :current_password])
  end
end
