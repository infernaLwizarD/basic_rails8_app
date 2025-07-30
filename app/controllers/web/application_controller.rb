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

  def render_turbo_response(template, options = {})
    options[:breadcrumbs] ||= false
    options[:flash] ||= false
    options[:with_html] ||= false

    stream = [turbo_stream.update('content', template: template)]
    stream.push(render_turbo_breadcrumbs) if options[:breadcrumbs]
    stream.push(render_turbo_flash) if options[:flash]

    respond_to do |format|
      format.html { render template: template } if options[:with_html]
      format.turbo_stream do
        render turbo_stream: stream
      end
    end
  end

  private

  def user_not_authorized
    flash.now[:alert] = 'Для выполнения данного действия необходимо авторизоваться.'
    redirect_to(root_path)
  end
end
