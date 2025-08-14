class Web::HomeController < Web::ApplicationController
  def index
    @current_time = Time.zone.now.strftime('%H:%M:%S')
    @main_title = 'Демонстрация возможностей Hotwire'

    render_turbo_response('web/home/index', breadcrumbs: true)
  end

  def change_frame1_color
    @frame1_color = generate_random_color

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update('frame1', partial: 'web/home/frame1',
                                                           locals: { background_color: @frame1_color })
      end
    end
  end

  def change_frame2_color
    @frame2_color = generate_random_color

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update('frame2', partial: 'web/home/frame2',
                                                           locals: { background_color: @frame2_color })
      end
    end
  end

  def reset_colors
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update('frame1', partial: 'web/home/frame1', locals: { background_color: nil }),
          turbo_stream.update('frame2', partial: 'web/home/frame2', locals: { background_color: nil })
        ]
      end
    end
  end

  private

  def generate_random_color
    "##{SecureRandom.hex(3)}"
  end
end
