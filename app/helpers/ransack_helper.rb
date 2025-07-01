# Кастомный хелпер для sort_link с поддержкой Turbo Stream
module RansackHelper
  def turbo_sort_link(search, attribute, *args, &)
    options = args.extract_options!
    options[:data] ||= {}
    options[:data][:turbo_stream] = true
    args << options

    sort_link(search, attribute, *args, &)
  end
end
