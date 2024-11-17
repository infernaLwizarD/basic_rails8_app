class Web::ApplicationController < ApplicationController
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash.now[:alert] = 'Для выполнения данного действия необходимо авторизоваться.'
    redirect_to(root_path)
  end
end
