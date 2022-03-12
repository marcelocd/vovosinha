class ApiController < ApplicationController
  include Pagy::Backend

  FORBIDDEN_STATUS_CODE = 403
  NOT_FOUND_STATUS_CODE = 404
  UNPROCESSABLE_ENTITY_STATUS_CODE = 422

  skip_before_action :verify_authenticity_token, only: %i[create update destroy]
end