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

    respond_to do |format|
      format.turbo_stream { render 'web/users/turbo_streams/success' }
      format.html
    end
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
    if @user.save
      flash[:notice] = 'Пользователь успешно создан'

      respond_to do |format|
        format.turbo_stream { render 'web/users/turbo_streams/success' }
        format.html { redirect_to @user }
      end
    else
      respond_to do |format|
        format.turbo_stream { render 'web/users/turbo_streams/failed' }
        format.html { render :new }
      end
    end
  end

  def update
    if @user.update(user_params)
      flash[:notice] = 'Пользователь отредактирован' if @user.saved_changes?

      respond_to do |format|
        format.turbo_stream { render 'web/users/turbo_streams/success' }
        format.html { redirect_to action: :show }
      end
    else
      respond_to do |format|
        format.turbo_stream { render 'web/users/turbo_streams/failed' }
        format.html { render :edit }
      end
    end
  end

  def destroy
    @user.discard
    flash[:notice] = 'Пользователь удалён'

    respond_to do |format|
      format.turbo_stream { render 'web/users/turbo_streams/success' }
      format.html { redirect_to users_path }
    end
  end

  def restore
    @user.undiscard!
    flash[:notice] = 'Пользователь восстановлен'
    respond_with @user
  end

  def lock
    @user.lock_access!(send_instructions: false)
    flash[:notice] = 'Пользователь заблокирован'
    respond_with @user
  end

  def unlock
    @user.unlock_access!
    flash[:notice] = 'Пользователь разблокирован'
    respond_with @user
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

    params.require(:user).permit(attributes)
  end
end
