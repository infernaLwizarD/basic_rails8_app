module ApplicationHelper
  def ts_link_to(name, path, options = {})
    options[:data] ||= {}
    options[:data][:turbo_stream] = true
    link_to(name, path, options)
  end
end
