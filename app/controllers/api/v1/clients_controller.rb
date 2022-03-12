class Api::V1::ClientsController < ApiController
  before_action :find_client, only: %i[show edit update destroy]
  before_action :require_same_account, only: %i[show new create edit update destroy]

  def index
    pagy, records = pagy(clients, page: params[:page])
    render jsonapi: records, meta: { pagy: pagy_metadata(pagy) }
  end

  def show
    if @client.present?
      render_client
    else
      render_client_not_found_error
    end
  end

  def new ; end

  def create
    @client = Client.new(permitted_params.merge(account: current_account))
    if @client.save
      render_client
    else
      render_client_errors
    end
  end

  def edit
    if @client.present?
      render_client
    else
      render_client_not_found_error
    end
  end

  def update
    if !@client.present?
      render_client_not_found_error
    elsif @client.update(permitted_params.merge(last_updated_by: current_user))
      render_client
    else
      render_client_errors
    end
  end

  def destroy
    if @client.update(deleted_at: DateTime.now, deleted_by: current_user)
      render json: { success: I18n.t('success.models.client.deleted') }
    else
      render_client_errors
    end
  end

  private

  def clients
    @clients ||= current_account.clients
                                .active
                                .order(:first_name, :last_name)
  end

  def find_client
    @client ||= current_account.clients
                               .active
                               .find_by_id(params[:id])
  end

  def permitted_params
    params.permit(*%i[birthdate
                      email
                      first_name
                      gender
                      last_name
                      main_phone_number
                      second_phone_number])
  end

  def render_client
    if @client.present?
      render jsonapi: @client, include: %w[account last_updated_by]
    else
      render_client_not_found_error
    end
  end

  def render_client_errors
    render json: { errors: @client.errors.full_messages }, status: UNPROCESSABLE_ENTITY_STATUS_CODE
  end

  def require_same_account
		unless (current_user.account == current_account) || current_user.admin?
			render json: { errors: [t('errors.messages.permission_denied')] }, status: FORBIDDEN_STATUS_CODE
		end
	end

  def render_client_not_found_error
    render json: { errors: [t('errors.models.client.not_found')] }, status: NOT_FOUND_STATUS_CODE
  end
end
