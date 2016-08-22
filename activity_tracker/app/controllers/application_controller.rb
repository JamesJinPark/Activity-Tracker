class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    if admin_signed_in? and patient_signed_in?
      if @route == "patients" or request.path == "/patients/sign_in" or request.path == "/patients"
        sign_out current_admin
        patient_path(resource)
      elsif @route == "admins" or request.path == "/admins/sign_in"   
        sign_out current_patient
        admins_path(resource)
      else
        root_path        
      end
    elsif patient_signed_in? 
      patient_path(resource)
    elsif admin_signed_in? 
      admins_path(resource)
    else 
      root_path
    end  
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:login, :email, :mrn, :password, :remember_me])
  end


end
