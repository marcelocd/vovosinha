class ApplicationController < ActionController::Base
  before_action :set_locale
  
  layout :layout
  
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username])
  end

  def set_locale
    I18n.locale = params[:locale] || session[:locale] || I18n.default_locale
    session[:locale] = I18n.locale
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
