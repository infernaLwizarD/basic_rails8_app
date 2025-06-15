class Web::UsersController < Web::ApplicationController
  respond_to :html, :json # , :turbo_stream
  before_action :find_and_authorize_user, except: %i[new create index]

  def index
    authorize User

    @users = policy_scope(User)
    @users_cnt = @users.count

    @main_title = 'Пользователи'
    @breadcrumbs = [
      {
        title: 'Пользователи'
      }
    ]

    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: [
          render_turbo_breadcrumbs,
          turbo_stream.update('content', template: 'web/users/index')
        ]
      end
    end
  end

  def show
    @user.password = nil

    @breadcrumbs = [
      {
        title: 'Пользователи',
        path: users_path
      },
      {
        title: @user.email,
        path: user_path(@user)
      }
    ]

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          render_turbo_breadcrumbs,
          turbo_stream.update('content', template: 'web/users/show')
        ]
      end
      format.html
    end
    # respond_with @user
  end

  def new
    authorize User

    @user = User.new

    @breadcrumbs = [
      {
        title: 'Пользователи',
        path: users_path
      },
      {
        title: 'Новый пользователь'
      }
    ]

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          render_turbo_breadcrumbs,
          turbo_stream.update('content', template: 'web/users/new')
        ]
      end
      format.html
    end
  end

  def edit
    @breadcrumbs = [
      {
        title: 'Пользователи',
        path: users_path
      },
      {
        title: @user.email,
        path: user_path(@user)
      }
    ]

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          render_turbo_flash,
          turbo_stream.update('content', template: 'web/users/edit')
        ]
      end
      format.html
    end
  end

  def create
    authorize User

    @user = User.new(user_params)

    flash.now[:notice] = 'Пользователь успешно создан' if @user.save

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          render_turbo_flash,
          turbo_stream.update('content', template: 'web/users/show')
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
            render_turbo_flash,
            turbo_stream.update('content', template: 'web/users/show')
          ]
        end
        format.html { redirect_to action: :show }
      end
    else
      render :edit
    end
  end

  def destroy
    @user.discard

    flash.now[:alert] = 'Пользователь удалён'
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          render_turbo_flash,
          turbo_stream.update('content', template: 'web/users/show')
        ]
      end
      format.html { redirect_to action: :show }
    end
  end

  def restore
    @user.undiscard!
    flash.now[:notice] = 'Пользователь восстановлен'

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          render_turbo_flash,
          turbo_stream.update('content', template: 'web/users/show')
        ]
      end
      format.html { redirect_to action: :show }
    end
  end

  def lock
    @user.lock_access!(send_instructions: false)
    flash.now[:notice] = 'Пользователь заблокирован'

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          render_turbo_flash,
          turbo_stream.update('content', template: 'web/users/show')
        ]
      end
      format.html { redirect_to action: :show }
    end
  end

  def unlock
    @user.unlock_access!
    flash.now[:notice] = 'Пользователь разблокирован'

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          render_turbo_flash,
          turbo_stream.update('content', template: 'web/users/show')
        ]
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
