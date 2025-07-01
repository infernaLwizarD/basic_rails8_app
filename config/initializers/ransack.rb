Ransack.configure do |config|
  config.custom_arrows = {
    up_arrow: " <i class='fa-solid fa-arrow-up'></i>".html_safe,
    down_arrow: " <i class='fa-solid fa-arrow-down'></i>".html_safe,
    default_arrow: ''
  }
end
