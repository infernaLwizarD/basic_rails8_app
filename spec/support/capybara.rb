if ENV['SELENIUM_REMOTE_URL']
  Capybara.server = :puma, { Silent: true }
  Capybara.server_host = '0.0.0.0'
  Capybara.server_port = ENV['WEB_PORT'] || 3001
  Capybara.default_max_wait_time = 5
  Capybara.app_host = "http://#{Socket.gethostname}:#{Capybara.server_port}"

  Capybara.register_driver :chrome_headless do |app|
    options = Selenium::WebDriver::Chrome::Options.new

    # [--- VNC Viewer off
    options.add_argument('--headless')
    options.add_argument('--disable-gpu')
    #---]
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-dev-shm-usage')
    options.add_argument('--window-size=1400,1400')

    Capybara::Selenium::Driver.new(app, browser: :remote, url: ENV['SELENIUM_REMOTE_URL'], options:)
  end
end

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, js: true, type: :system) do
    if ENV['SELENIUM_REMOTE_URL']
      driven_by :chrome_headless
    else
      driven_by Capybara.javascript_driver
    end
  end
end
