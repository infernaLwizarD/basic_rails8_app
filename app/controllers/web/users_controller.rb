class Web::UsersController < Web::ApplicationController
  respond_to :html, :json
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
    flash[:notice] = 'Пользователь успешно создан' if @user.save
    respond_with @user
  end

  def update
    if @user.update(user_params)
      flash[:notice] = 'Пользователь отредактирован' if @user.saved_changes?
      redirect_to action: :show
    else
      render :edit
    end
  end

  def destroy
    @user.discard
    flash[:notice] = 'Пользователь удалён'
    redirect_to users_path
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
    attributes = %i[username email password]

    if params[:action] == 'create'
      params[:user].delete(:password_confirmation) if params[:user][:password].blank?
      attributes.push(:password_confirmation)
    end

    params.require(:user).permit(attributes)
  end
end
