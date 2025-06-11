class Web::UsersController < Web::ApplicationController
  respond_to :html, :json # , :turbo_stream
  before_action :find_and_authorize_user, except: %i[new create index]

  def index
    authorize User

    @users = policy_scope(User)
    @users_cnt = @users.count

    respond_with @users
  end

  def show
    @user.password = nil

    respond_with @user
  end

  def new
    authorize User

    @user = User.new
    respond_with @user
  end

  def edit
  end

  def create
    authorize User

    @user = User.new(user_params)

    flash.now[:notice] = 'Пользователь успешно создан' if @user.save

    # respond_with @user
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          render_turbo_breadcrumbs,
          render_turbo_flash,
          turbo_stream.update('content_frame', template: 'web/users/show')
        ]
      end
      format.html
    end
  end

  def update
    if @user.update(user_params)
      flash.now[:notice] = 'Пользователь отредактирован' if @user.saved_changes?

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_breadcrumbs,
            render_turbo_flash,
            turbo_stream.update('content_frame', template: 'web/users/show')
          ]
        end
        format.html { redirect_to action: :show }
      end
      # redirect_to action: :show
    else
      render :edit
    end
  end

  def destroy
    @user.discard

    flash.now[:alert] = 'Пользователь удалён'
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [turbo_stream.update('content_frame', template: 'web/users/show'), render_turbo_flash]
      end
      format.html { redirect_to action: :show }
    end
  end

  def restore
    @user.undiscard!
    flash.now[:notice] = 'Пользователь восстановлен'

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [turbo_stream.update('content_frame', template: 'web/users/show'), render_turbo_flash]
      end
      format.html { redirect_to action: :show }
    end
  end

  def lock
    @user.lock_access!(send_instructions: false)
    flash.now[:notice] = 'Пользователь заблокирован'

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [turbo_stream.update('content_frame', template: 'web/users/show'), render_turbo_flash]
      end
      format.html { redirect_to action: :show }
    end
  end

  def unlock
    @user.unlock_access!
    flash.now[:notice] = 'Пользователь разблокирован'

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [turbo_stream.update('content_frame', template: 'web/users/show'), render_turbo_flash]
      end
      format.html { redirect_to action: :show }
    end
  end

  private

  def find_and_authorize_user
    @user = User.find(params[:id])
    authorize @user
  end

  def user_params
    params[:user].delete(:password) if params.dig(:user, :password).blank?
    attributes = %i[username email password role]

    if params[:action] == 'create'
      params[:user].delete(:password_confirmation) if params[:user][:password].blank?
      attributes.push(:password_confirmation)
    end

    params.expect(user: attributes)
  end
end
