class ApiController < ApplicationController
  include Pagy::Backend

  skip_before_action :verify_authenticity_token, only: %i[create update destroy]
  
  before_action :require_active_user

  private

  def require_active_user
    if current_user.present? && current_user.inactive?
      render json: { errors: [t('errors.models.user.inactive')] }
    end
  end
end