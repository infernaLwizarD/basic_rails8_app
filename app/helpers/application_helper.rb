module ApplicationHelper
  def ts_link_to(name, path, options = {})
    options[:data] ||= {}
    options[:data][:turbo_stream] = true
    link_to(name, path, options)
  end

  def field_class(object, field)
    base_class = 'form-control form-control-sm w-500 mw-100'
    if object.errors[field].present?
      "#{base_class} is-invalid"
    else
      base_class
    end
  end

  def error_message_for(object, field)
    return if object.errors[field].blank?

    content_tag(:div, class: 'invalid-feedback d-block') do
      object.errors[field].join(', ')
    end
  end
end
