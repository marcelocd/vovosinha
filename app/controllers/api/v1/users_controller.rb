class Api::V1::UsersController < ApiController
  def index
    pagy, records = pagy(users, page: params[:page])
    render jsonapi: records, meta: { pagy: pagy_metadata(pagy) }
  end

  private

  def users
    User.order(:first_name)
  end
end