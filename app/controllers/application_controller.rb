class ApplicationController < ActionController::Base
  layout :layout
  
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username])
  end

  private

  def layout
    if is_a?(Devise::SessionsController) || is_a?(Devise::PasswordsController)
      'devise'
    else
      'application'
    end
  end
end
