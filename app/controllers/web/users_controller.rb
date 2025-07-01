class Web::UsersController < Web::ApplicationController
  # respond_to :html, :json # , :turbo_stream
  before_action :find_and_authorize_user, except: %i[new create index]

  def index
    authorize User

    @q = policy_scope(User).default_order.ransack(params[:q])
    @users_cnt = @q.result.count

    @pagy, @users = pagy(@q.result)

    @main_title = 'Пользователи'
    set_user_breadcrumbs

    render_turbo_response('web/users/index', breadcrumbs: true)
  end

  def show
    @user.password = nil

    set_user_breadcrumbs({ title: @user.email, path: user_path(@user) })

    render_turbo_response('web/users/show', breadcrumbs: true)
  end

  def new
    authorize User

    @user = User.new

    set_user_breadcrumbs({ title: 'Новый пользователь' })

    render_turbo_response('web/users/new', breadcrumbs: true)
  end

  def edit
    set_user_breadcrumbs({ title: @user.email, path: user_path(@user) })

    render_turbo_response('web/users/edit', flash: true)
  end

  def create
    authorize User

    @user = User.new(user_params)

    if @user.save
      flash.now[:notice] = 'Пользователь успешно создан'
      set_user_breadcrumbs({ title: @user.email, path: user_path(@user) })
      render_turbo_response('web/users/show', breadcrumbs: true, flash: true)
    else
      set_user_breadcrumbs({ title: 'Новый пользователь' })
      render_turbo_response('web/users/new', breadcrumbs: true)
    end
  end

  def update
    if @user.update(user_params)
      flash.now[:notice] = 'Пользователь отредактирован' if @user.saved_changes?

      render_turbo_response('web/users/show', flash: true)
    else
      render_turbo_response('web/users/edit')
    end
  end

  def destroy
    @user.discard

    flash.now[:alert] = 'Пользователь удалён'

    render_turbo_response('web/users/show', flash: true)
  end

  def restore
    @user.undiscard!
    flash.now[:notice] = 'Пользователь восстановлен'

    render_turbo_response('web/users/show', flash: true)
  end

  def lock
    @user.lock_access!(send_instructions: false)
    flash.now[:notice] = 'Пользователь заблокирован'

    render_turbo_response('web/users/show', flash: true)
  end

  def unlock
    @user.unlock_access!
    flash.now[:notice] = 'Пользователь разблокирован'

    render_turbo_response('web/users/show', flash: true)
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

  def set_user_breadcrumbs(additional = nil)
    @breadcrumbs = [
      { title: 'Пользователи', path: users_path }
    ]
    @breadcrumbs << additional if additional
  end
end
