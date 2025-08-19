class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  include Pundit::Authorization
  include Pagy::Backend

  protected

  def render_not_found
    render file: Rails.public_path.join('404.html'), layout: false, status: :not_found
  end
end
