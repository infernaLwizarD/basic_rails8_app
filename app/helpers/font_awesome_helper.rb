module FontAwesomeHelper
  def icon(style, name, text = nil, html_options = {})
    if text.is_a?(Hash)
      html_options = text
      text = nil
    end

    content_class = "#{style} fa-#{name}"
    content_class << " #{html_options[:class]}" if html_options.key?(:class)
    html_options[:class] = content_class
    html_options['aria-hidden'] ||= true

    html = content_tag(:i, nil, html_options)
    html << ' ' << text.to_s if text.present?
    html
  end
end
