class Api::V1::AccountsController < ApiController
  before_action :find_account, only: %i[show edit update destroy]
  before_action :require_same_account, only: %i[show edit update]
  before_action :require_admin, only: %i[index new create destroy]

  def index
    pagy, records = pagy(accounts, page: params[:page])
    render jsonapi: records, meta: { pagy: pagy_metadata(pagy) }
  end

  def show
    render_account
  end

  def new ; end

  def create
    @account = Account.new(permitted_params)
    if @account.save
      render_account
    else
      render_account_errors
    end
  end

  def edit
    render_account
  end

  def update
    if @account.update(permitted_params.merge(last_updated_by: current_user))
      render_account
    else
      render_account_errors
    end
  end

  def destroy
    if @account.update(deleted_at: DateTime.now, deleted_by: current_user)
      render json: { success: I18n.t('success.models.account.deleted') }
    else
      render_account_errors
    end
  end

  private

  def accounts
    @accounts ||= Account.active.order(:company_name)
  end

  def find_account
    @account ||= Account.active.find_by_id(params[:id])
  end

  def permitted_params
    params.permit(:company_name)
  end

  def render_account
    render jsonapi: @account, include: %w[owned_by
                                          last_updated_by
                                          users]
  end

  def render_account_errors
    render json: { errors: @account.errors.full_messages }
  end

  def require_same_account
		unless (current_user.account == current_account && current_user.manager?) || current_user.admin?
			render json: { errors: [t('errors.messages.permission_denied')] }
		end
	end

  def require_admin
		unless current_user.admin?
			render json: { errors: [t('errors.messages.permission_denied')] }
		end
	end
end
