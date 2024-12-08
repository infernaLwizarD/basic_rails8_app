class Web::ApplicationController < ApplicationController
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # def render_main_turbo_stream(**)
  #   render('layouts/lte/turbo_streams/main', **)
  # end

  def render_turbo_flash
    turbo_stream.update('flash', partial: 'layouts/lte/partials/flash')
  end

  def render_turbo_breadcrumbs
    turbo_stream.update('breadcrumbs', partial: 'layouts/lte/partials/breadcrumbs')
  end

  private

  def user_not_authorized
    flash.now[:alert] = 'Для выполнения данного действия необходимо авторизоваться.'
    redirect_to(root_path)
  end
end
