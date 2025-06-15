class Web::HomeController < Web::ApplicationController
  def index
    @current_time = Time.now.strftime('%H:%M:%S')
    @main_title = 'Главная страница'
    @breadcrumbs = [{ title: 'Тестовый раздел', path: '#' }, { title: "Подраздел #{@current_time}" }]

    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update('breadcrumbs', partial: 'layouts/lte/partials/breadcrumbs'),
          turbo_stream.update('content', partial: 'web/home/content_frame')
          # turbo_stream.update('test_frame', partial: 'web/home/test_frame')
        ]
      end
    end
  end
end
