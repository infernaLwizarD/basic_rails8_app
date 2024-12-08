module CommonHelper
  def draw_main_title(options = {})
    options[:title] ||= ''
    options[:size] ||= 1

    %(
      <section class="content-header"> \
      <div class="container-fluid"> \
          <div class="row mb-2"> \
              <div class="col-sm-6"> \
                  <h#{options[:size]}>#{options[:title]}</h#{options[:size]}> \
              </div> \
              <div class="col-sm-6"></div> \
          </div> \
      </div> \
      </section> \
    ).html_safe
  end

  def checkbox_val(object, options = {})
    if object.present?
      if options[:yn_format].present?
        'Да'
      else
        icon('fas', 'check')
      end
    elsif options[:yn_format].present?
      'Нет'
    else
      icon('fas', 'times')
    end.html_safe
  end

  def serialized_array(array, options = {})
    options[:prefix] ||= ''
    array&.collect { |i| "#{options[:prefix]}#{i}" }&.join("\n")
  end

  def truncate_str(str, length = 21)
    if str.length > length
      "#{str.slice(0, length).strip}..."
    else
      str
    end
  end
end
