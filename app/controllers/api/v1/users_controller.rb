class Api::V1::UsersController < ApiController
  before_action :find_user, only: %i[show edit update destroy]
  before_action :require_same_user, only: %i[edit update]
  before_action :require_manager, only: %i[new create destroy]

  def index
    pagy, records = pagy(users, page: params[:page])
    render jsonapi: records, meta: { pagy: pagy_metadata(pagy) }
  end

  def show
    render_user
  end

  def new ; end

  def create
    @user = User.new(permitted_params)
    if @user.save
      render_user
    else
      render_user_errors
    end
  end

  def edit
    render_user
  end

  def update
    if @user.update(permitted_params)
      render_user
    else
      render_user_errors
    end
  end

  def destroy
    if @user.update(deleted_at: DateTime.now, deleted_by: current_user)
      render json: { success: I18n.t('success.models.user.deleted') }
    else
      render_user_errors
    end
  end

  private

  def users
    @users ||= User.active.order(:first_name)
  end

  def find_user
    @user ||= User.find_by_id(params[:id])
  end

  def permitted_params
    params.permit(:username,
                  :first_name,
                  :last_name,
                  :email,
                  :password,
                  :confirmation_password,
                  :birthdate,
                  :role)
  end

  def render_user
    render jsonapi: @user, include: %i[full_name]
  end

  def render_user_errors
    render json: { errors: @user.errors.full_messages }
  end

  def require_same_user
		unless current_user == @user || current_user.admin? || current_user.manager?
			render json: { errors: [t('errors.models.user.edit.same_user')] }
		end
	end

  def require_manager
		unless current_user.manager? || current_user.admin?
			render json: { errors: [t('errors.messages.permission_denied')] }
		end
	end
end