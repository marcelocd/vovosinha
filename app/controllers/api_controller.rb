class ApiController < ApplicationController
  include Pagy::Backend

  skip_before_action :verify_authenticity_token, only: %i[create update destroy]
end